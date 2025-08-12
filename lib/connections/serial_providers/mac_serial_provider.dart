import 'dart:developer' as developer;
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';

class RS232Provider implements RS232ProviderInterface {
  late SerialPort port;

  @override
  Future<({List<({String address, String name})> devices, bool supported})>
  getSerialOptions() async {
    final ports = SerialPort.availablePorts;
    final allPorts = Set<String>.from(ports);
    for (final port in ports) {
      if (port.startsWith('/dev/cu.')) {
        allPorts.add(port.replaceFirst('/dev/cu.', '/dev/tty.'));
      }
    }

    final sortedPorts = allPorts.toList()
      ..sort((a, b) {
        int score(String s) {
          if (s.contains('312') && s.contains('/tty')) return -1;
          if (s.contains('312')) return 0;
          if (s.contains('/tty')) return 1;
          return 2;
        }
        final scoreA = score(a);
        final scoreB = score(b);
        if (scoreA != scoreB) return scoreA.compareTo(scoreB);
        return a.compareTo(b);
      });

    final fullPortList =
        sortedPorts
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

    return Future.value((supported: true, devices: fullPortList));
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
  Future<Uint8List?> read(
    int length, {
    Duration timeout = const Duration(milliseconds: 1000),
  }) async {
    final response = port.read(length, timeout: timeout.inMicroseconds);
    return Future.value(Uint8List.fromList(response));
  }

  @override
  Future<void> write(Uint8List data) {
    port.write(data);
    return Future.value();
  }
}
