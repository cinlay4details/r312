import 'dart:developer' as developer;

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';
import 'package:r312/utils/parse_mqtt_url.dart';

class MqttProvider implements MqttProviderInterface {

  MqttProvider({required this.onMessage});
  final void Function(String message) onMessage;

  late MqttServerClient _client;

  String _topic = 'test';
  bool isConnected = false;

  @override
  Future<bool> connect(String address) async {
    final options = parseMqttUrl(address);
    
    _client = MqttServerClient('${options.protocol}://${options.host}', '');
    _client.useWebSocket = options.protocol.contains('ws');
    _client.port = options.port;

    _client..setProtocolV311()
    ..websocketProtocols = MqttClientConstants.protocolsSingleDefault
    ..keepAlivePeriod = 20
    ..connectTimeoutPeriod = 5000 // milliseconds
    ..onDisconnected = _onDisconnected;

    final connectionMessage = MqttConnectMessage()
      .startClean();
    _client.connectionMessage = connectionMessage;

    try {
      developer.log('mqtt connecting...');
      await _client.connect(options.username, options.password);
    } on Exception catch (e) {
      developer.log('mqtt connection failed $e');
      _client.disconnect();
      return false;
    }

    developer.log('mqtt subscripting...');
    _client.updates!.listen(_onData);
    _topic = options.topic;
    return _client.subscribe(_topic, MqttQos.atMostOnce) != null;
  }

  void _onDisconnected() {
    developer.log('mqtt disconnected');
    isConnected = false;
  }

  void _onData(List<MqttReceivedMessage<MqttMessage>> event) {
    final message = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(
      message.payload.message,
    );
    developer.log('mqtt data: $payload');
    onMessage(payload);
  }

  @override
  void disconnect() {
    if (!isConnected) {
      developer.log('mqtt disconnect called but not connected');
      return;
    }
    developer.log('mqtt disconnecting...');
    _client.disconnect();
  }

  @override
  void publish(String message) {
    final builder = MqttClientPayloadBuilder()
    ..addString(message);
    _client.publishMessage(_topic, MqttQos.atMostOnce, builder.payload!);
  } 
}
