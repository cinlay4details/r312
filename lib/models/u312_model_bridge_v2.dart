import 'dart:convert';
import 'dart:developer' as developer;

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_api.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/connections/mqtt_providers/platform_mqtt_provider.dart';

class U312ModelBridgeV2 {
  U312ModelBridgeV2(String boxAddress, String mqttAddress) {
    _box = U312BoxApi(boxAddress);
    _mqttProvider = MqttProvider(onMessage: _onMqttMessage);
    _mqttAddress = mqttAddress;
  }
  late MqttProviderInterface _mqttProvider;
  late final String _mqttAddress;
  late U312BoxApi _box;

  Future<void> connect() async {
    await _box.connect();
    await _mqttProvider.connect(_mqttAddress);
    // reset
    await _box.setChannelLevelV2(Channel.a, _channelA);
    await _box.setChannelLevelV2(Channel.b, _channelB);
    await _box.setMALevelV2(_multiAdjust);
    await _box.switchToMode(_mode);
  }

  Future<void> disconnect() async {
    _mqttProvider.disconnect();
    await _box.close();
  }

  Mode _mode = Mode.wave;
  int _channelA = 0;
  int _channelB = 0;
  int _multiAdjust = 0;

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
            value = value.clamp(0, 99);
            if (channel == 'A') {
              developer.log('Setting channel A to $value');
              _box.setChannelLevelV2(Channel.a, value);
              _channelA = value;
            } else if (channel == 'B') {
              developer.log('Setting channel B to $value');
              _box.setChannelLevelV2(Channel.b, value);
              _channelB = value;
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
            _mode = modeValue;
            _box.switchToMode(_mode);
          case 'MA':
            var value = int.tryParse(parts[2]);
            if (value == null) {
              developer.log('Invalid value for ma (${parts[2]})');
              return;
            }
            value = value.clamp(0, 99);
            developer.log('Setting MA to $value');
            _multiAdjust = value;
            _box.setMALevelV2(_multiAdjust);
          default:
            developer.log('Unknown set command: $command');
        }
      // _ack();
      case 'SYN':
        developer.log('Client request SYN/ACK');
        final ackData = {
          'mode': _mode.value,
          'chA': _channelA,
          'chB': _channelB,
          'ma': _multiAdjust,
        };
        _mqttProvider.publish('ACK_${jsonEncode(ackData)}');
      case 'ACK':
        developer.log('Ignore acknowledge command: ${parts[1]}');
      default:
        developer.log('Unknown command: $command');
    }
  }

  String get uri {
    return Uri(
      scheme: 'https',
      host: 'cinlay4details.github.io',
      path: 'r312',
      queryParameters: {'remote': _mqttAddress},
    ).toString();
  }
}
