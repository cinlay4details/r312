import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:r312/connections/serial_providers/android_serial_provider.dart'
    as android_provider;
import 'package:r312/connections/serial_providers/mac_serial_provider.dart'
    as mac_provider;
import 'package:r312/connections/serial_providers/rs232_provider.dart';

class RS232Provider implements RS232ProviderInterface {
  RS232Provider() {
    developer.log('use io_serial_provider');
    if (Platform.isAndroid) {
      developer.log('use android');
      _implementation = android_provider.RS323Provider();
    } else if (Platform.isMacOS) {
      developer.log('use mac');
      _implementation = mac_provider.RS232Provider();
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}',
      );
    }
  }
  late RS232ProviderInterface _implementation;

  @override
  Future<
    ({
      List<({String address, String name})> devices,
      bool supported,
    })
  >
  getSerialOptions() async {
    return _implementation.getSerialOptions();
  }

  @override
  Future<void> close() {
    return _implementation.close();
  }

  @override
  Future<void> open(String address, {int baudRate = 19200}) async {
    return _implementation.open(address, baudRate: baudRate);
  }

  @override
  Future<Uint8List> read(int length) {
    return _implementation.read(length);
  }

  @override
  Future<void> write(Uint8List data) {
    return _implementation.write(data);
  }
}
