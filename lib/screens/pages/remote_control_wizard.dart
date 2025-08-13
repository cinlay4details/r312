import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_remote.dart';
import 'package:r312/screens/pages/wizard/mqtt_broker_wizard_page.dart';

class RemoteControlWizard extends StatefulWidget {
  const RemoteControlWizard({this.onPanelPicked, super.key});

  final void Function(dynamic model)? onPanelPicked;

  @override
  State<RemoteControlWizard> createState() => _RemoteControlWizardState();
}

class _RemoteControlWizardState extends State<RemoteControlWizard> {
  final int _currentPage = 0;

  late final List<Widget> _pages;

  Future<void> _connect(BuildContext context, String address) async {
    final model = U312ModelRemote(address);
    widget.onPanelPicked?.call(model);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    final remote = Uri.base.queryParameters['remote'];
    if (remote != null && remote.isNotEmpty) {
      // If 'remote' query parameter is present, navigate to RemoteControlWizard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        developer.log(
          'Navigating to RemoteControlWizard with remote: $remote',
          name: 'RemoteControlWizard',
        );
        _connect(context, remote);
      });
    }
    _pages = [
      MqttBrokerWizardPage(
        onSelect: (String address) async {
          // Handle MQTT broker address selection
          await _connect(context, address);
        },
      ),
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
