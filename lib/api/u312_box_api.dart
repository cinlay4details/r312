import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_serial.dart';

enum Channel { a, b }

class U312State {
  Mode mode = Mode.wave;
  int channelA = 0;
  int channelB = 0;
  double maLevel = 0;
}

class U312BoxApi {
  U312BoxApi(this._address) {
    box = U312BoxSerial();
  }
  final String _address;
  late final U312BoxSerial box;

  final U312State _remoteState = U312State();
  final U312State _targetState = U312State();

  Future<void>? _applyStateHandle;
  bool _isApplying = false;
  bool _isClosing = false;

  Future<void> _applyState() async {
    _isApplying = true;
    var appliedChanges = true;
    while (!_isClosing && appliedChanges) {
      appliedChanges = false;
      if (_remoteState.mode != _targetState.mode) {
        final mode = _targetState.mode;
        await _switchToMode(mode);
        _remoteState.mode = mode;
        appliedChanges = true;
      }
      if (_remoteState.channelA != _targetState.channelA) {
        final channelA = _targetState.channelA;
        await _setChannelLevel(Channel.a, channelA);
        _remoteState.channelA = channelA;
        appliedChanges = true;
      }
      if (_remoteState.channelB != _targetState.channelB) {
        final channelB = _targetState.channelB;
        await _setChannelLevel(Channel.b, channelB);
        _remoteState.channelB = channelB;
        appliedChanges = true;
      }
      if (_remoteState.maLevel != _targetState.maLevel) {
        final maLevel = _targetState.maLevel;
        await _setMALevel(maLevel);
        _remoteState.maLevel = maLevel;
        appliedChanges = true;
      }
    }
    _isApplying = false;
    return;
  }

  void _requestUpdateState() {
    if (_isApplying) {
      return;
    }
    _applyStateHandle = _applyState();
  }

  Future<void> connect() async {
    await box.open(_address);
    await _init();
    _applyStateHandle = _applyState();
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
    final safeLevel = level.clamp(0, 255);
    if (channel == Channel.a) {
      _targetState.channelA = safeLevel;
    } else {
      _targetState.channelB = safeLevel;
    }
    _requestUpdateState();
  }

  Future<void> _setChannelLevel(Channel channel, int level) async {
    final address = channel == Channel.a ? 0x4064 : 0x4065;
    await box.poke(address, Uint8List.fromList([level]));
    developer.log('Channel ${channel.name.toUpperCase()} Level: $level');
  }

  Future<void> setMALevel(double level) async {
    final safeLevel = level.clamp(0.0, 1.0);
    _targetState.maLevel = safeLevel;
    _requestUpdateState();
  }

  Future<void> _setMALevel(double level) async {
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
    _targetState.mode = mode;
    _requestUpdateState();
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
    await _applyStateHandle;
    await box.close();
  }
}
