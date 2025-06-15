import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:r312/connections/serial_providers/platform_serial_provider.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';
import 'package:r312/models/u312_model_bridge.dart';
import 'package:r312/screens/box_twin_screen.dart';
import 'package:r312/screens/widgets/connecting_wizard_page.dart';
import 'package:r312/screens/widgets/mqtt_broker_wizard_page.dart';
import 'package:r312/screens/widgets/serial_selector_wizard_page.dart';
import 'package:r312/screens/widgets/serial_unavailable_wizard_page.dart';

class BridgeWizard extends StatefulWidget {
  const BridgeWizard({super.key});

  @override
  State<BridgeWizard> createState() => _BridgeWizardState();
}

class _BridgeWizardState extends State<BridgeWizard> {
  int _currentPage = 0;
  bool _isLoading = true;
  bool _isSupported = true;
  late final RS232ProviderInterface? _serialProvider;
  late String? _selectedDeviceAddress;
  final ValueNotifier<String?> _connectionErrorNotifier = ValueNotifier(null);

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _serialProvider = RS232Provider();
    _loadSerialOptions();
  }

  Future<void> _loadSerialOptions() async {
    final options = await _serialProvider!.getSerialOptions();
    setState(() {
      _isSupported = options.supported;
      _isLoading = false;
      if (!_isSupported) {
        _pages.add(const SerialUnavailableWizardPage());
      } else {
        _pages
          ..add(
            SerialSelectorWizardPage(
              devices: options.devices,
              onSelect: (String address) async {
                setState(() {
                  _selectedDeviceAddress = address;
                  _currentPage += 1; // Navigate to the "connecting" page
                });
              },
            ),
          )
          ..add(
            MqttBrokerWizardPage(
              onSelect: (String address) async {
                setState(() {
                  _currentPage += 1; // Navigate to the "connecting" page
                  _connectionErrorNotifier.value = null; // Reset error state
                });

                try {
                  final model = U312ModelBridge(
                    _selectedDeviceAddress ?? '',
                    address,
                  );
                  await model.connect();
                  // Handle successful connection
                  if (mounted) {
                    // Explicitly check if the widget is still mounted
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<BoxTwinWidget>(
                        builder: (context) => BoxTwinWidget(appState: model),
                      ),
                    );
                  }

                  // ignore: avoid_catches_without_on_clauses allow all failures
                } catch (e) {
                  // Handle connection failure
                  developer.log('Failed to connect: $e');
                  _connectionErrorNotifier.value =
                      e.toString(); // Set error message
                }
              },
            ),
          )
          ..add(
            ConnectingWizardPage(
              connectionErrorNotifier: _connectionErrorNotifier,
            ),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge Wizard'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pages[_currentPage],
    );
  }
}
