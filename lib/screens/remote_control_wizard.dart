import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_remote.dart';
import 'package:r312/screens/box_twin_screen.dart';
import 'package:r312/screens/widgets/connecting_wizard_page.dart';
import 'package:r312/screens/widgets/mqtt_broker_wizard_page.dart';

class RemoteControlWizard extends StatefulWidget {
  const RemoteControlWizard({
    super.key,
  });

  @override
  State<RemoteControlWizard> createState() => _RemoteControlWizardState();
}

class _RemoteControlWizardState extends State<RemoteControlWizard> {
  int _currentPage = 0;
  final ValueNotifier<String?> _connectionErrorNotifier = ValueNotifier(null);

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      MqttBrokerWizardPage(
        onSelect: (String address) async {
          setState(() {
            _currentPage = 1; // Navigate to the "connecting" page
            _connectionErrorNotifier.value = null; // Reset error state
          });

          try {
            final model = U312ModelRemote(address);
            await model.connect();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => BoxTwinWidget(appState: model),
            ),);
            // ignore: avoid_catches_without_on_clauses show all errors
          } catch (e) {
            // Handle connection failure
            developer.log('Failed to connect: $e');
            _connectionErrorNotifier.value = e.toString(); // Set error message
          }
        },
      ),
      ConnectingWizardPage(connectionErrorNotifier: _connectionErrorNotifier),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Control Wizard'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _pages[_currentPage],
    );
  }
}
