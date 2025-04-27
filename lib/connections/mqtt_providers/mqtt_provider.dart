abstract interface class MqttProviderInterface {
  factory MqttProviderInterface({
    required void Function(String message) onMessage,
  }) = _MqttProviderInterfaceImpl;

  Future<bool> connect(String address);
  void publish(String message);
}

// Private implementation class to enforce the constructor
class _MqttProviderInterfaceImpl implements MqttProviderInterface {
  _MqttProviderInterfaceImpl({required this.onMessage});

  final void Function(String message) onMessage;

  @override
  Future<bool> connect(String address) async {
    // Implement connect logic
    return true;
  }

  @override
  void publish(String message) {
    // Implement publish logic
  }
}
