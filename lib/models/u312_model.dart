import 'package:flutter/widgets.dart';
import 'package:r312/api/modes.dart';

abstract class U312Model extends ChangeNotifier {
  // public constants
  double get battery => 0;
  double get power => 1;
  double get volume => 1;

  // public read state only
  final _screenText = ['      ^__^      ',
                       '      r312      ',];
  List<String> get screenText => _screenText;

  double _chA = 0; // chA light
  double get chA => _chA;

  double _chB = 0; // chB light
  double get chB => _chB;

  // private state
  String _connectionType = '^__^';

  String _getDialReadingAsDisplay(double normalized) {
    final scaled = (normalized * 99).floor();
    return scaled.toString().padLeft(2, '0');
  }

  void _applyUpdates() {
    final aLevel = (_aAndBDial * _chADial) / (255 * 255);
    final bLevel = (_aAndBDial * _chBDial) / (255 * 255);
    _chA = aLevel;
    _chB = bLevel;
    _screenText[0] = [
      'A${_getDialReadingAsDisplay(aLevel)}',
      'B${_getDialReadingAsDisplay(bLevel)}',
      ' ${_mode.name}',
     ].join(' ');
    final maLevel = _multiAdjustDial / 255;
    _screenText[1] = [
      'MA   ${_getDialReadingAsDisplay(maLevel)}',
      ' $_connectionType',
    ].join(' ');
    notifyListeners();
  }

  // controllers

  Mode _mode = Mode.wave;
  Mode get mode => _mode;
  set mode(Mode value) {
    _mode = value;
    _applyUpdates();
  }

  void pressRight() {
    final nextIndex = (_mode.index + 1) % Mode.values.length;
    mode = Mode.values[nextIndex];
  }

  void pressLeft() {
    var previousIndex = _mode.index - 1;
    if (previousIndex < 0) {
      previousIndex = Mode.values.length - 1;
    }
    mode = Mode.values[previousIndex];
  }

  int _aAndBDial = 0;
  int get aAndBDial => _aAndBDial;
  set aAndBDial(int value) {
    final clamped = value.clamp(0, 255);
    _aAndBDial = clamped;
    _applyUpdates();
  }

  int _chADial = 0;
  int get chADial => _chADial;
  set chADial(int value) {
    final clamped = value.clamp(0, 255);
    _chADial = clamped;
    _applyUpdates();
  }

  int _chBDial = 0;
  int get chBDial => _chBDial;
  set chBDial(int value) {
    final clamped = value.clamp(0, 255);
    _chBDial = clamped;
    _applyUpdates();
  }

  int _multiAdjustDial = 0;
  int get multiAdjustDial => _multiAdjustDial;
  set multiAdjustDial(int value) {
    final clamped = value.clamp(0, 255);
    _multiAdjustDial = clamped;
    _applyUpdates();
  }

  void connect();

  void disconnect();

  Future<void> pressDisconnect() async {
    disconnect();
  }

  Future<void> init(String connectionType) async {
    _connectionType = connectionType;
    mode = Mode.wave;
    chADial = 0;
    chBDial = 0;
    aAndBDial = 0;
    multiAdjustDial = 0;
  }
}
