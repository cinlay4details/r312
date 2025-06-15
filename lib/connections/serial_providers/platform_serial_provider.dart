export 'stub_serial_provider.dart'
    if (dart.library.io) 'io_serial_provider.dart'
    if (dart.library.js) 'web_serial_provider.dart';
