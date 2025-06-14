import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';

class RS323Provider implements RS232ProviderInterface {
  BluetoothConnection? _connection;

  final List<int> _buffer = [];

  @override
  Future<({
    List<({String address, String name})> devices,
    bool supported
  })> getSerialOptions() async {
    final blueClassic = FlutterBlueClassic(usesFineLocation: true);
    final devices = await blueClassic.bondedDevices;
    if (devices == null || devices.isEmpty) {
      throw Exception('No bonded devices found');
    }
    developer.log(
      'bonded devices: ${devices.map((device) => device.name).toList()}',
    );
    return (
      devices: devices
          .map(
            (device) => (
              address: device.address,
              name: device.name ?? 'Unknown (${device.address})',
            ),
          )
          .toList(),
      supported: true,
    );
  }

  @override
  Future<void> close() async {
    await _connection?.close();
    _buffer.clear();
  }

  @override
  Future<void> open(String address, {int baudRate = 19200}) async {
    developer.log('use android');
    // background

    const config = FlutterBackgroundAndroidConfig(
      notificationTitle: 'flutter_background example app',
      notificationText:
          'Background notification for keeping the example app running in the background',
      notificationIcon: AndroidResource(name: 'background_icon'),
    );
    var hasPermissions = await FlutterBackground.hasPermissions;
    // if (!hasPermissions) {
    //   if (!hasPermissions) {
    //     throw Exception('Background permissions not granted');
    //   }
    // }
    hasPermissions = await FlutterBackground.initialize(androidConfig: config);
    if (hasPermissions) {
      final backgroundExecution =
          await FlutterBackground.enableBackgroundExecution();
      if (backgroundExecution) {
        developer.log('Background execution enabled');
      } else {
        throw Exception('Failed to enable background execution');
      }
    } else {
      throw Exception('Failed to initialize background permissions');
    }
    developer.log('Connecting to device: $address');

    // blue tooth
    final blueClassic = FlutterBlueClassic(usesFineLocation: true);
    _connection = await blueClassic.connect(address);
    if (_connection == null) {
      throw Exception('Failed to connect to device');
    }
    _connection!.input?.listen(_buffer.addAll);
  }

  @override
  Future<Uint8List?> read(int length, {
    Duration timeout = const Duration(milliseconds: 1000),
  }) async {
    var time = 0;
    while (_buffer.length < length) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      time += 100;
      if (time > timeout.inMilliseconds) {
        developer.log('Read operation timed out after $timeout');
        return null;
      }
    }
    final data = Uint8List.fromList(_buffer.sublist(0, length));
    _buffer.removeRange(0, length);
    return data;
  }

  @override
  Future<void> write(Uint8List data) {
    _connection?.output.add(data);
    return Future.value();
  }
}
