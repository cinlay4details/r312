import 'package:flutter/material.dart';

enum ConnectionStatus { connecting, connected, error, disconnecting }

class ConnectionInfo extends ChangeNotifier {
  ConnectionStatus _status = ConnectionStatus.connecting;
  String? _errorMessage;

  ConnectionStatus get status => _status;
  String? get errorMessage => _errorMessage;

  set status(ConnectionStatus value) {
    _status = value;
    notifyListeners();
  }

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}
