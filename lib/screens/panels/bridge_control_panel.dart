import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_bridge.dart';
import 'package:r312/screens/widgets/connection_info_widget.dart';

class BridgeControlPanel extends StatelessWidget {
  BridgeControlPanel({required this.model, required this.onRemove, super.key}) {
    model.connect();
  }
  final U312ModelBridge model;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row: Title and Remove button
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                'Bridge',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.yellow, // <-- yellow icon
                ),
                tooltip: 'Remove Panel',
                onPressed: () async {
                  await model.disconnect();
                  onRemove();
                },
              ),
            ),
          ],
        ),
        ConnectionInfoWidget(
          label: 'Box',
          connectionInfo: model.boxConnectionInfo,
        ),
        ConnectionInfoWidget(
          label: 'Remote',
          connectionInfo: model.mqttConnectionInfo,
        ),
        // ...existing code...
      ],
    );
  }
}
