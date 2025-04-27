import 'package:flutter/widgets.dart';
import 'package:r312/api/modes.dart';

class U312ModelStub extends ChangeNotifier {
  // public constants
  double get battery => 0;
  double get power => 1;
  double get volume => 1;

  // public read state only
  final _screenText = ['      ^__^      ', 'Connecting...   '];
  List<String> get screenText => _screenText;

  double _chA = 0;
  double get chA => _chA;

  double _chB = 0;
  double get chB => _chB;

  String _getDialReadingAsDisplay(double normalized) {
    final scaled = (normalized * 99).round();
    return scaled.toString().padLeft(2, '0');
  }

  void _applyChannelOrModeUpdate() {
    final aLevel = (_aAndBDial * _chADial) / (255 * 255);
    final bLevel = (_aAndBDial * _chBDial) / (255 * 255);
    _chA = aLevel;
    _chB = bLevel;
    _screenText[0] = [
      'A${_getDialReadingAsDisplay(aLevel)}',
      'B${_getDialReadingAsDisplay(bLevel)}',
      ' ${_mode.name}',
     ].join(' ');
     _screenText[1] = 'Connected.';
    notifyListeners();
  }

  // controllers

  Mode _mode = Mode.wave;
  Mode get mode => _mode;
  set mode(Mode value) {
    _mode = value;
    _applyChannelOrModeUpdate();
  }

  void pressRight() {
    final nextIndex = (_mode.index + 1) % Mode.values.length;
    mode = Mode.values[nextIndex];
    _applyChannelOrModeUpdate();
  }

  void pressLeft() {
    var previousIndex = _mode.index - 1;
    if (previousIndex < 0) {
      previousIndex = Mode.values.length - 1;
    }
    mode = Mode.values[previousIndex];
    _applyChannelOrModeUpdate();
  }

  int _aAndBDial = 0;
  int get aAndBDial => _aAndBDial;
  set aAndBDial(int value) {
    final clamped = value.clamp(0, 255);
    _aAndBDial = clamped;
    _applyChannelOrModeUpdate();
  }

  int _chADial = 0;
  int get chADial => _chADial;
  set chADial(int value) {
    final clamped = value.clamp(0, 255);
    _chADial = clamped;
    _applyChannelOrModeUpdate();
  }

  int _chBDial = 0;
  int get chBDial => _chBDial;
  set chBDial(int value) {
    final clamped = value.clamp(0, 255);
    _chBDial = clamped;
    _applyChannelOrModeUpdate();
  }

  int _multiAdjustDial = 0;
  int get multiAdjustDial => _multiAdjustDial;
  set multiAdjustDial(int value) {
    final clamped = value.clamp(0, 255);
    _multiAdjustDial = clamped;
    notifyListeners();
  }

  void connect() {
    _applyChannelOrModeUpdate();
  }
}
