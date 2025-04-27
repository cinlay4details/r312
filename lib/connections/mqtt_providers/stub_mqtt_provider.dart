import 'package:r312/connections/mqtt_providers/mqtt_provider.dart';

class MqttProvider implements MqttProviderInterface {
  MqttProvider({required this.onMessage});
  final void Function(String message) onMessage;

  @override
  Future<bool> connect(String address) async {
    throw Exception('StubMqttProvider does not support connect');
  }

  @override
  void publish(String message) {
    throw Exception('StubMqttProvider does not support publish');
  }
}
