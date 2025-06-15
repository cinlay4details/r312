import 'dart:convert';
import 'dart:developer' as developer;

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_api.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/connections/mqtt_providers/platform_mqtt_provider.dart';
import 'package:r312/models/u312_model.dart';

class U312ModelBridge extends U312Model {
  U312ModelBridge(String boxAddress, String mqttAddress) {
    _box = U312BoxApi(boxAddress);
    _mqttProvider = MqttProvider(onMessage: _onMqttMessage);
    _mqttAddress = mqttAddress;
  }
  late MqttProviderInterface _mqttProvider;
  late final String _mqttAddress;
  late U312BoxApi _box;

  @override
  Future<void> connect() async {
    await _box.connect();
    await init('Bridge');
    await _mqttProvider.connect(_mqttAddress);
  }

  @override
  Future<void> disconnect() async {
    _mqttProvider.disconnect();
    await _box.close();
  }

  void _onMqttMessage(String command) {
    developer.log('Received command: $command');
    final parts = command.split('_');
    switch (parts[0]) {
      case 'SET':
        switch (parts[1]) {
          case 'CHANNEL':
            final channel = parts[2];
            var value = int.tryParse(parts[3]);
            if (value == null) {
              developer.log(
                'Invalid value for channel: $channel (${parts[3]})',
              );
              return;
            }
            value = value.clamp(0, 255);
            if (channel == 'A') {
              developer.log('Setting channel A to $value');
              super.chADial = value;
              _updatePowerLevels();
            } else if (channel == 'B') {
              developer.log('Setting channel B to $value');
              super.chBDial = value;
              _updatePowerLevels();
            } else if (channel == 'AB') {
              developer.log('Setting channel AB to $value');
              super.aAndBDial = value;
              _updatePowerLevels();
            } else {
              developer.log('Unknown channel: $channel');
            }
          case 'MODE':
            final modeValue = Mode.values.firstWhere(
              (m) =>
                  m
                      .toString()
                      .split('.')
                      .last
                      .toUpperCase()
                      .replaceAll('_', '') ==
                  parts[2],
              orElse: () => Mode.wave,
            );
            developer.log('Setting mode to $modeValue');
            super.mode = modeValue;
            _box.switchToMode(super.mode);
          case 'MA':
            var value = int.tryParse(parts[2]);
            if (value == null) {
              developer.log('Invalid value for ma (${parts[2]})');
              return;
            }
            value = value.clamp(0, 255);
            developer.log('Setting MA to $value');
            super.multiAdjustDial = value;
            _updateMALevel();
          default:
            developer.log('Unknown set command: $command');
        }
      // _ack();
      case 'SYN':
        developer.log('Client request SYN/ACK');
        _ack();
      case 'ACK':
        developer.log('Ignore acknowledge command: ${parts[1]}');
      // Handle ACK messages if needed
      default:
        developer.log('Unknown command: $command');
    }
  }

  Future<void> _ack() async {
    final ackData = {
      'mode': mode.value,
      'chA': chADial,
      'chB': chBDial,
      'aAndB': aAndBDial,
      'ma': multiAdjustDial,
    };
    _mqttProvider.publish('ACK_${jsonEncode(ackData)}');
  }

  Future<void> _updatePowerLevels() async {
    final aLevel = (((aAndBDial * chADial) / (255 * 255)) * 255).round();
    final bLevel = (((aAndBDial * chBDial) / (255 * 255)) * 255).round();
    // the a&b dial is virtual
    await _box.setChannelLevel(Channel.a, aLevel);
    await _box.setChannelLevel(Channel.b, bLevel);
  }

  Future<void> _updateMALevel() async {
    final maLevel = multiAdjustDial / 255;
    // the a&b dial is virtual
    await _box.setMALevel(maLevel);
  }

  // disable buttons
  @override
  void pressRight() {
    // do nothing
  }
  @override
  void pressLeft() {
    // do nothing
  }
  @override
  set chADial(int value) {
    // do nothing
  }
  @override
  set chBDial(int value) {
    // do nothing
  }
  @override
  set aAndBDial(int value) {
    // do nothing
  }
  @override
  set multiAdjustDial(int value) {
    // do nothing
  }

  // qr for linking
  @override
  String get deepLink {
    final uri = Uri(
      scheme: 'https',
      host: 'cinlay4details.github.io',
      path: 'r312',
      queryParameters: {'remote': _mqttAddress},
    );
    return uri.toString();
  }
}
