import 'package:flutter/material.dart';
import 'package:r312/api/modes.dart';
import 'package:r312/models/u312_model_remote.dart';
import 'package:r312/screens/widgets/mode_picker_widget.dart';
import 'package:r312/screens/widgets/pot_picker_widget.dart';

class RemoteControlPanel extends StatelessWidget {
  const RemoteControlPanel({
    required this.model,
    required this.onRemove,
    super.key,
  });
  final U312ModelRemote model;
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
                'Remote',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Remove Panel',
                onPressed: () async {
                  await model.disconnect();
                  onRemove();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row: Mode picker
        ModePickerWidget(
          modeValue: model.mode.value,
          label: 'Mode',
          onChanged:
              (v) => model.mode = Mode.values.firstWhere((m) => m.value == v),
        ),
        const SizedBox(height: 12),
        // Channel A pot picker
        PotPickerWidget(
          value: model.channelA,
          label: 'Channel A',
          onChanged: (v) => model.channelA = v,
        ),
        const SizedBox(height: 12),
        // Channel B pot picker
        PotPickerWidget(
          value: model.channelB,
          label: 'Channel B',
          onChanged: (v) => model.channelB = v,
        ),
        const SizedBox(height: 12),
        // Multi-Adjust pot picker
        PotPickerWidget(
          value: model.multiAdjust,
          label: 'Multi-Adjust',
          onChanged: (v) => model.multiAdjust = v,
        ),
      ],
    );
  }
}
