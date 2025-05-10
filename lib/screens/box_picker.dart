import 'package:flutter/material.dart';
import 'package:r312/screens/bridge_wizard.dart';
import 'package:r312/screens/direct_control_wizard.dart';
import 'package:r312/screens/remote_control_wizard.dart';

class BoxPicker extends StatelessWidget {
  const BoxPicker({required this.addPage, super.key});
  final void Function(Map<String, dynamic>) addPage;

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
              icon: Icons.settings_remote,
              label: 'Direct Control',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => DirectControlWizard(
                      onClose: () {
                        Navigator.pop(context);
                      },
                      addPage: addPage, // Pass addPage to the wizard
                    ),
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
                    builder: (context) => BridgeWizard(
                      onClose: () {
                        Navigator.pop(context);
                      },
                      addPage: addPage, // Pass addPage to the wizard
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
                    builder: (context) => RemoteControlWizard(
                      onClose: () {
                        Navigator.pop(context);
                      },
                      addPage: addPage, // Pass addPage to the wizard
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
