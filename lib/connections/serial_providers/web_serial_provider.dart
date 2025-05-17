import 'dart:developer' as developer;
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:r312/connections/serial_providers/rs232_provider.dart';
import 'package:serial/serial.dart';
import 'package:web/web.dart';

class RS232Provider implements RS232ProviderInterface {
  late SerialPort port;
  late WritableStreamDefaultWriter writer;
  late ReadableStreamDefaultReader reader;

  @override
  Future<({List<({String address, String name})> devices, bool supported})>
  getSerialOptions() async {
    var supported = false;
    try {
      supported = window.navigator.serial != null;
      // ignore: avoid_catches_without_on_clauses any error means it is not supported
    } catch (e) {
      developer.log('Serial API not supported: $e');
    }
    // window.navigator.serial;
    return (
      devices: [(address: '!', name: 'Click to open the serial port selector')],
      supported: supported,
    );
  }

  @override
  Future<void> open(String address, {int baudRate = 9600}) async {
    port = await window.navigator.serial.requestPort().toDart;
    await port.open(baudRate: baudRate).toDart;
    writer = port.writable!.getWriter();
    reader = port.readable!.getReader() as ReadableStreamDefaultReader;
  }

  @override
  Future<void> close() {
    writer.releaseLock();
    reader.releaseLock();
    return port.close().toDart;
  }

  Future<ReadableStreamReadResult?>? _chunkWait;

  int _readId = 0;

  @override
  Future<Uint8List?> read(
    int length, {
    Duration timeout = const Duration(milliseconds: 1000),
  }) async {
    final readId = _readId++;
    developer.log('Reading $length bytes (id: $readId)');
    final buffer = Uint8List(length);
    var offset = 0;
    while (offset < length) {
      // the stream is a singleton, so waiting needs to be a singleton too
      _chunkWait ??= reader.read().toDart;
      final chunk = await Future.any([
        _chunkWait!,
        Future.delayed(timeout, () {
          return null;
        }),
      ]);
      if (chunk == null) {
        return null;
      }

      _chunkWait = null;
      final data = chunk.value;
      if (data == null || !data.isA<JSUint8Array>()) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        continue;
      }
      final array = (data as JSUint8Array).toDart;
      buffer.setAll(offset, array);
      offset += array.length;
    }
    return buffer;
  }

  @override
  Future<void> write(Uint8List data) {
    return writer.write(data.toJS).toDart;
  }
}
