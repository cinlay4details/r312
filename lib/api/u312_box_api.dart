import 'dart:async';
import 'dart:collection';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_serial.dart';

enum Channel { a, b }

class U312BoxApi {
  U312BoxApi(this._address) {
    box = U312BoxSerial();
  }
  final String _address;
  late final U312BoxSerial box;
  late final Queue<Future<void> Function()> _commands = Queue();
  late Future<void> _processCommandHandle;
  bool _isClosing = false;
  

  Future<void> _processCommands() async {
    while (_commands.isNotEmpty) {
      if (_isClosing) {
        break;
      }
      final command = _commands.removeFirst();
      if (_commands.isEmpty) {
        _commands.add(idle);
      }
      try {
        await command();
      } on Exception catch (e) {
        developer.log('Error processing command: $e');
      }
    }
    developer.log('All commands processed');
  }

  Future<void> connect() async {
    await box.open(_address);
    _commands.add(_init);
    _processCommandHandle = _processCommands();
  }

  Future<void> _disableBoxButtons() async {
    // disable box buttons
    await box.poke(0x4013, Uint8List.fromList([0x01, 0x01, 0x01, 0x01]));
  }

  Future<void> _init() async {
    // set box to default mode
    await _switchToMode(Mode.wave);
    // disable box dials
    await box.poke(
      0x400f,
      Uint8List.fromList([int.parse('00001001', radix: 2)]),
    );
    // set every po to zero (safety first)
    await _setMALevel(0);
    await _setChannelLevel(Channel.a, 0);
    await _setChannelLevel(Channel.b, 0);
    developer.log('Box initialized');
  }

  Future<void> setChannelLevel(Channel channel, int level) async {
    _commands.add(() => _setChannelLevel(channel, level));
  }
  Future<void> _setChannelLevel(Channel channel, int level) async {
    final clampedLevel = level.clamp(0, 255);
    final address = channel == Channel.a
        ? 0x4064
        : 0x4065;
    await box.poke(address, Uint8List.fromList([clampedLevel]));
    developer.log(
      'Channel ${channel.name.toUpperCase()} Level: $clampedLevel',
    );
  }

  Future<void> setMALevel(double level) async {
    _commands.add(() => _setMALevel(level));
  }

  Future<void> _setMALevel(double level) async {
    if (level < 0 || level > 1) {
      throw Exception('Level must be between 0 and 1');
    }
    final lowerBound = await box.peek(0x4086);
    final upperBound = await box.peek(0x4087);
    final range = upperBound - lowerBound;
    final scaledLevel = (lowerBound + (range * level)).round();
    await box.poke(0x420d, Uint8List.fromList([scaledLevel]));
    developer.log(
      'MA Level: $scaledLevel'
      ' (lower: $lowerBound, upper: $upperBound, range: $range)',
    );
  }

  Future<void> switchToMode(Mode mode) async {
    _commands.add(() => _switchToMode(mode));
  }

  Future<void> _switchToMode(Mode mode) async {
    await box.poke(0x407B, Uint8List.fromList([mode.value]));
    await box.poke(0x4070, Uint8List.fromList([0x04, 0x12]));
    await Future<void>.delayed(const Duration(milliseconds: 18));
    await _disableBoxButtons();
  }

  Future<void> idle() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  Future<void> close() async {
    _isClosing = true;
    await _processCommandHandle;
    await box.close();
  }
}
