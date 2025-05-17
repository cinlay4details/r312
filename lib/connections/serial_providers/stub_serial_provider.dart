import 'dart:typed_data';

import 'package:r312/connections/serial_providers/rs232_provider.dart';

class RS232Provider implements RS232ProviderInterface {
  @override
  Future<void> close() {
    throw UnimplementedError('close() has not been implemented.');
  }

  @override
  Future<void> open(String address, {int baudRate = 9600}) {
    throw UnimplementedError('open() has not been implemented.');
  }

  @override
  Future<Uint8List?> read(int length, {
    Duration timeout = const Duration(milliseconds: 1000),}) {
    throw UnimplementedError('read() has not been implemented.');
  }

  @override
  Future<void> write(Uint8List data) {
    throw UnimplementedError('write() has not been implemented.');
  }

  @override
  Future<
    ({
      List<({String address, String name})> devices,
      bool supported,
    })
  >
  getSerialOptions() {
    throw UnimplementedError('getSerialOptions() has not been implemented.');
  }
}
