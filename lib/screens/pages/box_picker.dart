import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_stub.dart';
import 'package:r312/screens/pages/bridge_wizard.dart';
import 'package:r312/screens/pages/direct_control_wizard.dart';
import 'package:r312/screens/pages/remote_control_wizard.dart';

const enableTestStub = true;

class BoxPicker extends StatelessWidget {
  const BoxPicker({required this.onPanelPicked, super.key});

  final void Function(dynamic model)? onPanelPicked;

  @override
  Widget build(BuildContext context) {
    final remote = Uri.base.queryParameters['remote'];
    if (remote != null && remote.isNotEmpty) {
      // If 'remote' query parameter is present, navigate to RemoteControlWizard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        developer.log(
          'Navigating to RemoteControlWizard with remote: $remote',
          name: 'BoxPicker',
        );
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const RemoteControlWizard(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select Control Mode')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (enableTestStub)
              _buildOption(
                context,
                icon: Icons.bug_report,
                label: 'Test Stub',
                onTap: () {
                  onPanelPicked?.call(U312ModelStub());
                },
              ),
            _buildOption(
              context,
              icon: Icons.settings_remote,
              label: 'Direct Control',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<DirectControlWizard>(
                    builder:
                        (context) =>
                            DirectControlWizard(onPanelPicked: onPanelPicked),
                  ),
                );
              },
            ),
            _buildOption(
              context,
              icon: Icons.link,
              label: 'Bridge',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<BridgeWizard>(
                    builder:
                        (context) => BridgeWizard(onPanelPicked: onPanelPicked),
                  ),
                );
              },
            ),
            _buildOption(
              context,
              icon: Icons.wifi,
              label: 'Remote Control',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<RemoteControlWizard>(
                    builder:
                        (context) =>
                            RemoteControlWizard(onPanelPicked: onPanelPicked),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      // Add mouse cursor to indicate clickable buttons
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
