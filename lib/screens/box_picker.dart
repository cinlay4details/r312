import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_stub.dart';
import 'package:r312/screens/box_twin_screen.dart';
import 'package:r312/screens/bridge_wizard.dart';
import 'package:r312/screens/direct_control_wizard.dart';
import 'package:r312/screens/remote_control_wizard.dart';

class BoxPicker extends StatelessWidget {
  const BoxPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Control Mode')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOption(
              context,
              icon: Icons.bug_report,
              label: 'Test Stub',
              onTap: () {
                final model = U312ModelStub();
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => BoxTwinWidget(appState: model),
                  ),
                );
              },
            ),
            _buildOption(
              context,
              icon: Icons.settings_remote,
              label: 'Direct Control',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const DirectControlWizard(),
                  ),
                );
              },
            ),
            _buildOption(
              context,
              icon: Icons.link,
              label: 'Bridge',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const BridgeWizard(
                    ),
                  ),
                );
              },
            ),
            _buildOption(
              context,
              icon: Icons.wifi,
              label: 'Remote Control',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const RemoteControlWizard(
                    ),
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
