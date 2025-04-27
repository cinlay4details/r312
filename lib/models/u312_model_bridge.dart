import 'dart:developer' as developer;

import 'package:r312/api/modes.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/connections/mqtt_providers/platform_mqtt_provider.dart';
import 'package:r312/models/u312_model_direct.dart';

class U312ModelBridge extends U312ModelDirect {
  U312ModelBridge(super.address, this._mqttAddress) {
    _mqttProvider = MqttProvider(onMessage: _onMqttMessage);
  }
  late MqttProviderInterface _mqttProvider;
  late final String _mqttAddress;
  
  @override
  Future<void> connect() async {
    await super.connect();
    await _mqttProvider.connect(_mqttAddress);
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
            } else if (channel == 'B') {
              developer.log('Setting channel B to $value');
              super.chBDial = value;
            } else if (channel == 'AB') {
              developer.log('Setting channel AB to $value');
              super.aAndBDial = value;
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
                      .replaceAll(' ', '') ==
                  parts[2],
              orElse: () => Mode.wave,
            );
            developer.log('Setting mode to $modeValue');
            super.mode = modeValue;
          case 'MA':
            var value = int.tryParse(parts[2]);
            if (value == null) {
              developer.log('Invalid value for ma (${parts[2]})');
              return;
            }
            value = value.clamp(0, 255);
            developer.log('Setting MA to $value');
            super.multiAdjustDial = value;
        }
    }
  }
}
