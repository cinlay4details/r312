enum ConnectionStatus { connecting, connected, error, disconnecting }

class ConnectionInfo {
  ConnectionStatus status = ConnectionStatus.connecting;
  String? errorMessage;
}
