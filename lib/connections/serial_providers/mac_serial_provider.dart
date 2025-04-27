import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';

class RS232Provider implements RS232ProviderInterface {
  late SerialPort port;

  @override
  Future<
    ({
      List<({String address, String name})> devices,
      bool supported,
    })
  >
  getSerialOptions() async {
    final ports = SerialPort.availablePorts;
    final allPorts = Set<String>.from(ports);
    for (final port in ports) {
      if (port.startsWith('/dev/cu.')) {
        allPorts.add(port.replaceFirst('/dev/cu.', '/dev/tty.'));
      }
    }
    final fullPortList =
        allPorts
            .map(
              (port) => (
                address: port,
                name: [
                  port.replaceFirst(RegExp(r'/dev/(tty|cu)\.'), ''),
                  '($port)',
                ].join(' '),
              ),
            )
            .toList();
    return Future.value((
      supported: true,
      devices: fullPortList,
    ),);
  }

  @override
  Future<void> close() {
    port.close();
    return Future.value();
  }

  @override
  Future<void> open(String address, {int baudRate = 9600}) {
    port = SerialPort(address);
    // do not set the baud rate as messing with the config breaks the port.
    // bluetooth is normally 9600 which is slower than the box anyways.
    if (!port.openReadWrite()) {
      throw Exception('Failed to open port');
    }
    return Future.value();
  }

  @override
  Future<Uint8List> read(int length) async {
    final response = port.read(length, timeout: 100);
    return Future.value(Uint8List.fromList(response));
  }

  @override
  Future<void> write(Uint8List data) {
    port.write(data);
    return Future.value();
  }
}
