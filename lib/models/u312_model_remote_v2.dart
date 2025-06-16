import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:r312/api/modes.dart';
import 'package:r312/api/u312_box_api.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/connections/mqtt_providers/platform_mqtt_provider.dart';

class U312ModelRemoteV2 {
  U312ModelRemoteV2(String address) {
    _address = address;
    _mqttProvider = MqttProvider(onMessage: _onMqttMessage);
  }
  late MqttProviderInterface _mqttProvider;
  late final String _address;
  late final Timer _synTimer;

  Future<void> connect() async {
    await _mqttProvider.connect(_address);
    _mqttProvider.publish('SYN');
    _synTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _mqttProvider.publish('SYN');
    });
  }

  Future<void> disconnect() async {
    _synTimer.cancel();
    _mqttProvider.disconnect();
  }

  Mode _mode = Mode.wave;
  Mode get mode => _mode;
  set mode(Mode value) {
    _mode = value;
    final modeName = value.name.toUpperCase().replaceAll(' ', '');
    return _mqttProvider.publish('SET_MODE_$modeName');
  }

  Future<void> _updateChannelLevel(Channel channel, int level) async {
    final channelName = channel.name.toUpperCase();
    return _mqttProvider.publish('SET_CHANNEL_${channelName}_$level');
  }

  int _channelA = 0;
  int get channelA => _channelA;
  set channelA(int value) {
    _channelA = value.clamp(0, 99);
    _updateChannelLevel(Channel.a, _channelA);
  }

  int _channelB = 0;
  int get channelB => _channelB;
  set channelB(int value) {
    _channelB = value.clamp(0, 99);
    _updateChannelLevel(Channel.b, _channelB);
  }

  int _multiAdjust = 0;
  int get multiAdjust => _multiAdjust;
  set multiAdjust(int value) {
    _multiAdjust = value.clamp(0, 99);
    return _mqttProvider.publish('SET_MA_$_multiAdjust');
  }

  void _onMqttMessage(String message) {
    developer.log('Received MQTT message: $message');
    final parts = message.split('_');
    switch (parts[0]) {
      case 'ACK':
        // Acknowledge the command
        developer.log('Acknowledged command: ${parts[1]}');
        final json = parts.sublist(1).join('_');
        final data = jsonDecode(json);
        _processAck(data);
      case 'SET':
      case 'SYN':
        developer.log('Ignore MQTT message: $message');
      default:
        developer.log('Unknown MQTT message: $message');
    }
  }

  void _processAck(dynamic data) {
    // Process the ACK data
    developer.log('Processing ACK data: $data');
    if (data is! Map<String, dynamic>) {
      developer.log('Invalid ACK data format: $data');
      return;
    }
    if (data.containsKey('mode')) {
      final modeValue = Mode.values.firstWhere(
        (m) => m.value == data['mode'],
        orElse: () => Mode.wave,
      );
      _mode = modeValue;
    }
    if (data.containsKey('chA')) {
      _channelA = (int.tryParse(data['chA'].toString()) ?? 0).clamp(0, 99);
    }
    if (data.containsKey('chB')) {
      _channelB = (int.tryParse(data['chB'].toString()) ?? 0).clamp(0, 99);
    }
    if (data.containsKey('ma')) {
      _multiAdjust = (int.tryParse(data['ma'].toString()) ?? 0).clamp(0, 99);
    }
  }

  String get uri {
    return Uri(
      scheme: 'https',
      host: 'cinlay4details.github.io',
      path: 'r312',
      queryParameters: {'remote': _address},
    ).toString();
  }
}
