import 'package:flutter/material.dart';
import 'package:r312/api/modes.dart';

class ModePickerWidget extends StatefulWidget {
  const ModePickerWidget({
    required this.modeValue,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final int modeValue;
  final ValueChanged<int> onChanged;
  final String label;

  @override
  State<ModePickerWidget> createState() => _ModePickerWidgetState();
}

class _ModePickerWidgetState extends State<ModePickerWidget> {
  late Mode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = Mode.values.firstWhere(
      (m) => m.value == widget.modeValue,
      orElse: () => Mode.values.first,
    );
  }

  @override
  void didUpdateWidget(covariant ModePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.modeValue != oldWidget.modeValue) {
      _currentMode = Mode.values.firstWhere(
        (m) => m.value == widget.modeValue,
        orElse: () => Mode.values.first,
      );
    }
  }

  void _setMode(Mode mode) {
    setState(() {
      _currentMode = mode;
    });
    widget.onChanged(mode.value);
  }

  void _prevMode() {
    const modes = Mode.values;
    final idx = modes.indexOf(_currentMode);
    final prevIdx = (idx - 1 + modes.length) % modes.length;
    _setMode(modes[prevIdx]);
  }

  void _nextMode() {
    const modes = Mode.values;
    final idx = modes.indexOf(_currentMode);
    final nextIdx = (idx + 1) % modes.length;
    _setMode(modes[nextIdx]);
  }

  @override
  Widget build(BuildContext context) {
    const modes = Mode.values;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Previous button (1/5)
            Expanded(
              child: ElevatedButton(
                onPressed: _prevMode,
                child: const Icon(Icons.arrow_left),
              ),
            ),
            // Dropdown (3/5)
            Expanded(
              flex: 3,
              child: DropdownButton<Mode>(
                isExpanded: true,
                value: _currentMode,
                items:
                    modes
                        .map(
                          (mode) => DropdownMenuItem<Mode>(
                            value: mode,
                            child: Text(mode.name),
                          ),
                        )
                        .toList(),
                onChanged: (mode) {
                  if (mode != null) _setMode(mode);
                },
              ),
            ),
            // Next button (1/5)
            Expanded(
              child: ElevatedButton(
                onPressed: _nextMode,
                child: const Icon(Icons.arrow_right),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
