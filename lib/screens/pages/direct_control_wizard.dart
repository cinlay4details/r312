import 'package:flutter/material.dart';
import 'package:r312/connections/serial_providers/platform_serial_provider.dart';
import 'package:r312/connections/serial_providers/rs232_provider.dart';
import 'package:r312/models/u312_model_direct.dart';
import 'package:r312/screens/pages/wizard/serial_selector_wizard_page.dart';
import 'package:r312/screens/pages/wizard/serial_unavailable_wizard_page.dart';

class DirectControlWizard extends StatefulWidget {
  const DirectControlWizard({this.onPanelPicked, super.key});

  final void Function(dynamic model)? onPanelPicked;

  @override
  State<DirectControlWizard> createState() => _DirectControlWizardState();
}

class _DirectControlWizardState extends State<DirectControlWizard> {
  final int _currentPage = 0;
  bool _isLoading = true;
  bool _isSupported = true;
  late final RS232ProviderInterface? _serialProvider;

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
        _pages.add(
          SerialSelectorWizardPage(
            devices: options.devices,
            onSelect: (String address) {
              final model = U312ModelDirect(address);
              widget.onPanelPicked?.call(model);
              Navigator.pop(context);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Control Wizard'),
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
