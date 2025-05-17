import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:r312/connections/serial_providers/platform_serial_provider.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';

class U312BoxSerial {
  U312BoxSerial();
  final RS232ProviderInterface rs232Provider = RS232Provider();
  int? deviceKey;

  Future<void> _write(Uint8List data, {bool checksum = true}) async {
    final buffer = Uint8List(data.length + (checksum ? 1 : 0))..setAll(0, data);

    if (checksum) {
      // calculate checksum
      var sum = 0;
      for (var i = 0; i < buffer.length; i++) {
        sum = sum + buffer[i] & 0xFF;
      }
      // add checksum to the end of the data
      buffer[buffer.length - 1] = sum;
    }

    if (deviceKey != null) {
      for (var i = 0; i < buffer.length; i++) {
        buffer[i] ^= deviceKey! ^ 0x55;
      }
    }

    // write to the box
    return rs232Provider.write(buffer);
  }

  Future<Uint8List?> _read(
    int length, {
    int timeout = 1000,
    bool checksum = true,
  }) async {
    // read from the box with timeout
    final response = await rs232Provider
        .read(
          length + (checksum ? 1 : 0),
          timeout: Duration(milliseconds: timeout),
        )
        .catchError((Object e) {
          developer.log('Read error: $e');
          return null; // Return null on error
        });
    if (response == null || response.length < length) {
      developer.log('Read error: response is null or too short');
      return null; // Return null if the response is empty
    }

    if (checksum) {
      // check checksum
      var expected = 0;
      for (var i = 0; i < response.length - 1; i++) {
        expected = expected + response[i] & 0xFF;
      }
      final actual = response[response.length - 1];
      if (expected != actual) {
        throw Exception('Checksum error (expected $expected, got $actual');
      }
      return response.sublist(0, response.length - 1);
    }
    return response;
  }

  Future<Uint8List?> _writeThenRead(
    Uint8List data,
    int readLength, {
    bool readChecksum = true,
    bool writeChecksum = true,
    int readTimeout = 1000,
  }) async {
    await _write(data, checksum: writeChecksum);
    if (readLength > 0) {
      return _read(readLength, timeout: readTimeout, checksum: readChecksum);
    }
    return null;
  }

  Future<void> _sync() async {
    // flush connection
    Uint8List? flush;
    do {
      flush = await _read(1, timeout: 100, checksum: false);
      developer.log('Flushing: $flush');
    } while (flush != null);
    // sync the connection
    for (var i = 0; i < 11; i++) {
      final response = await _writeThenRead(
        Uint8List.fromList([0x00]),
        1,
        writeChecksum: false,
        readChecksum: false,
      );
      developer.log('Sync response: $response');
      if (response != null) {
        if (response[0] == 0x07) {
          developer.log('Sync successful');
          return; // sync successful
        }
      }
    }
    throw Exception('Unable to sync with the box');
  }

  Future<void> _keyExchange() async {
    // exchange keys with the box
    const hostKey = 0x00; // for simplicity, always use 0x00
    final response = await _writeThenRead(
      Uint8List.fromList([0x2f, hostKey]),
      2,
    );

    if (response == null) {
      throw Exception('Key exchange failed');
    }

    final code = response[0];
    if (code != 0x21) {
      throw Exception('Unexpected key exchange code: $code');
    }

    final key = response[1];
    deviceKey = hostKey ^ key;
  }

  Future<void> open(String address) async {
    // connect to the box
    await rs232Provider.open(address);
    try {
      await _sync();
      await _keyExchange();
      return;
    } on Exception catch (e) {
      developer.log('Sync failed: $e');
    }
    developer.log('Assuming re-establishing connection');
    try {
      deviceKey = 0x00;
      await _sync();
      await _keyExchange();
      return;
    } on Exception catch (e) {
      developer.log('Re-establishing connection failed: $e');
      throw Exception('Unable to connect to the box');
    }
  }

  Future<void> close() async {
    if (deviceKey != null) {
      await poke(0x4213, Uint8List.fromList([0x00]));
      deviceKey = null;
    }
    await rs232Provider.close();
  }

  Future<int> peek(int address) async {
    // peek the box
    final response = await _writeThenRead(
      Uint8List.fromList([0x3C, (address >> 8) & 0xFF, address & 0xFF]),
      2,
    );
    if (response == null) {
      throw Exception('Peek failed');
    }
    if (response[0] != 0x22) {
      throw Exception('Unexpected peek response code: ${response[0]}');
    }
    return response[1];
  }

  Future<void> poke(int address, Uint8List data) async {
    if (data.isEmpty) {
      throw Exception('Poke cannot be empty');
    }
    if (data.length > 8) {
      throw Exception('Poke max length is 8 bytes');
    }
    // poke the box
    final response = await _writeThenRead(
      Uint8List.fromList([
        0x3D + (data.length << 4),
        (address >> 8) & 0xFF,
        address & 0xFF,
        ...(data.map((d) => d & 0xFF)),
      ]),
      1,
      readChecksum: false,
    );
    if (response == null) {
      throw Exception('Poke failed');
    }
    if (response[0] != 0x06) {
      throw Exception('Unexpected poke response code: ${response[0]}');
    }
  }
}
