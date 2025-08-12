import 'package:flutter/material.dart';
import 'package:r312/api/modes.dart';
import 'package:r312/models/u312_model_stub.dart';
import 'package:r312/screens/widgets/mode_picker_widget.dart';
import 'package:r312/screens/widgets/pot_picker_widget.dart';

class StubControlPanel extends StatelessWidget {
  const StubControlPanel({
    required this.model,
    required this.onRemove,
    super.key,
  });
  final U312ModelStub model;
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
                'Stub',
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
                onPressed: onRemove,
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
