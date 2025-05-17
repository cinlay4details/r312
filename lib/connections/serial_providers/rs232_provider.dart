import 'dart:async';
import 'dart:typed_data';

abstract interface class RS232ProviderInterface {
  Future<void> open(String address, {int baudRate = 19200});
  Future<void> write(Uint8List data);
  Future<Uint8List?> read(
    int length, {
    Duration timeout = const Duration(milliseconds: 1000),
  });
  Future<void> close();

  Future<({List<({String address, String name})> devices, bool supported})>
  getSerialOptions();
}
