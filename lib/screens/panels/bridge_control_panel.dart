import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_bridge.dart';

class BridgeControlPanel extends StatelessWidget {
  const BridgeControlPanel({required this.model, super.key});
  final U312ModelBridge model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bridge Control Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // First row: Title and Disconnect button
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Direct',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.power_off),
                    tooltip: 'Disconnect',
                    onPressed: model.disconnect,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
