import 'dart:developer' as developer;

import 'package:r312/api/modes.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/connections/mqtt_providers/platform_mqtt_provider.dart';
import 'package:r312/models/u312_model.dart';
import 'package:r312/utils/throttle.dart';

class U312ModelRemote extends U312Model {
  U312ModelRemote(String address) {
    _address = address;
    _mqttProvider = MqttProvider(onMessage: _onMqttMessage);
    _updateChannelALevelThrottled = throttle(
      () => _updateChannelLevel('A', chADial),
      const Duration(milliseconds: 100),
    );
    _updateChannelBLevelThrottled = throttle(
      () => _updateChannelLevel('B', chBDial),
      const Duration(milliseconds: 100),
    );
    _updateChannelAAndBLevelThrottled = throttle(
      () => _updateChannelLevel('AB', aAndBDial),
      const Duration(milliseconds: 100),
    );
    _updateMultiAdjustThrottled = throttle(
      _updateMultiAdjust,
      const Duration(milliseconds: 100),
    );
  }
  late MqttProviderInterface _mqttProvider;
  late final Future<void> Function() _updateChannelALevelThrottled;
  late final Future<void> Function() _updateChannelBLevelThrottled;
  late final Future<void> Function() _updateChannelAAndBLevelThrottled;
  late final Future<void> Function() _updateMultiAdjustThrottled;
  late final String _address;
  

  @override
  Future<void> connect() async {
    await _mqttProvider.connect(_address);
    await init('Remote');
  }

  @override
  Future<void> disconnect() async {
    _mqttProvider.disconnect();
  }

  @override
  set mode(Mode value) {
    super.mode = value;
    final modeName = value.name.toUpperCase().replaceAll(' ', '');
    return _mqttProvider.publish('SET_MODE_$modeName');
  }

  Future<void> _updateChannelLevel(String channel, int level) async {
    return _mqttProvider.publish('SET_CHANNEL_${channel}_$level');
  }

  @override
  set chADial(int value) {
    super.chADial = value;
    _updateChannelALevelThrottled();
  }

  @override
  set chBDial(int value) {
    super.chBDial = value;
    _updateChannelBLevelThrottled();
  }

  @override
  set aAndBDial(int value) {
    super.aAndBDial = value;
    _updateChannelAAndBLevelThrottled();
  }

  Future<void> _updateMultiAdjust() async {
    return _mqttProvider.publish('SET_MA_$multiAdjustDial');
  }

  @override
  set multiAdjustDial(int value) {
    super.multiAdjustDial = value;
    _updateMultiAdjustThrottled();
  }

  void _onMqttMessage(String message) {
    // Handle incoming MQTT messages here
    // For example, you can parse the message and update the UI or model state
    developer.log('Received MQTT message: $message');
  }
}
