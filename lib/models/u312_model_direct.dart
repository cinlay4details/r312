import 'dart:async';

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_api.dart';

class U312ModelDirect {
  U312ModelDirect(String address) {
    _box = U312BoxApi(address);
  }
  late U312BoxApi _box;

  Future<void> connect() async {
    await _box.connect();
    // reset
    await _box.setChannelLevelV2(Channel.a, _channelA);
    await _box.setChannelLevelV2(Channel.b, _channelB);
    await _box.setMALevelV2(_multiAdjust);
    await _box.switchToMode(_mode);
  }

  Future<void> disconnect() async {
    await _box.close();
  }

  Mode _mode = Mode.wave;
  Mode get mode => _mode;
  set mode(Mode value) {
    _mode = value;
    _box.switchToMode(_mode);
  }

  int _channelA = 0;
  int get channelA => _channelA;
  set channelA(int value) {
    _channelA = value.clamp(0, 99);
    _box.setChannelLevelV2(Channel.a, _channelA);
  }

  int _channelB = 0;
  int get channelB => _channelB;
  set channelB(int value) {
    _channelB = value.clamp(0, 99);
    _box.setChannelLevelV2(Channel.b, _channelB);
  }

  int _multiAdjust = 0;
  int get multiAdjust => _multiAdjust;
  set multiAdjust(int value) {
    _multiAdjust = value.clamp(0, 99);
    _box.setMALevelV2(_multiAdjust);
  }
}
