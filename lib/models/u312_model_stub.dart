import 'package:r312/api/modes.dart';

class U312ModelStub {
  Mode mode = Mode.wave;

  int _channelA = 0;
  int get channelA => _channelA;
  set channelA(int value) {
    _channelA = value.clamp(0, 99);
  }

  int _channelB = 0;
  int get channelB => _channelB;
  set channelB(int value) {
    _channelB = value.clamp(0, 99);
  }

  int _multiAdjust = 0;
  int get multiAdjust => _multiAdjust;
  set multiAdjust(int value) {
    _multiAdjust = value.clamp(0, 99);
  }
}
