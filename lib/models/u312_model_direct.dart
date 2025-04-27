import 'dart:async';

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_api.dart';
import 'package:r312/models/u312_model_stub.dart';
// import 'package:r312/utils/throttle.dart';

class U312ModelDirect extends U312ModelStub {
  U312ModelDirect(String address) {
    // _u312BoxSerial = U312BoxSerial();
    _box = U312BoxApi(address);
  }
  late U312BoxApi _box;

  @override
  Future<void> connect() async {
    await _box.connect();
  }

  @override
  set mode(Mode value) {
    super.mode = value;
    _box.switchToMode(super.mode);
  }

  Future<void> _updatePowerLevels() async {
    final aLevel = (((aAndBDial * chADial) / (255 * 255)) * 255).round();
    final bLevel = (((aAndBDial * chBDial) / (255 * 255)) * 255).round();
    // the a&b dial is virtual
    await _box.setChannelLevel(Channel.a, aLevel);
    await _box.setChannelLevel(Channel.b, bLevel);
  }

  @override
  set chADial(int value) {
    super.chADial = value;
    _updatePowerLevels();
  }

  @override
  set chBDial(int value) {
    super.chBDial = value;
    _updatePowerLevels();
  }

  @override
  set aAndBDial(int value) {
    super.aAndBDial = value;
    _updatePowerLevels();
  }

  Future<void> _updateMALevel() async {
    final maLevel = multiAdjustDial / 255;
    // the a&b dial is virtual
    await _box.setMALevel(maLevel);
  }

  @override
  set multiAdjustDial(int value) {
    super.multiAdjustDial = value;
    _updateMALevel();
  }

  @override
  void dispose() {
    _box.close();
    super.dispose();
  }
}
