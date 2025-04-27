import 'package:flutter/material.dart';

class ConnectingWizardPage extends StatelessWidget {
  const ConnectingWizardPage({
    required ValueNotifier<String?> connectionErrorNotifier, super.key,
  }) : _connectionErrorNotifier = connectionErrorNotifier;

  final ValueNotifier<String?> _connectionErrorNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _connectionErrorNotifier,
      builder: (context, connectionError, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (connectionError == null) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Connecting...', style: TextStyle(fontSize: 18)),
              ] else ...[
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Connection failed: $connectionError',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
