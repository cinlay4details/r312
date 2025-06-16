import 'package:flutter/material.dart';

class PotPickerWidget extends StatefulWidget {
  const PotPickerWidget({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });
  final int value;
  final ValueChanged<int> onChanged;
  final String label;

  @override
  State<PotPickerWidget> createState() => _PotPickerWidgetState();
}

class _PotPickerWidgetState extends State<PotPickerWidget> {
  late int _currentValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value.clamp(0, 99);
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void didUpdateWidget(PotPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value.clamp(0, 99);
      _controller.text = _currentValue.toString();
    }
  }

  void _updateValue(int newValue) {
    setState(() {
      _currentValue = newValue.clamp(0, 99);
      _controller.text = _currentValue.toString();
    });
    widget.onChanged(_currentValue);
  }

  void _onTextChanged(String text) {
    final val = int.tryParse(text);
    if (val != null) {
      _updateValue(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Slider(
                value: _currentValue.toDouble(),
                max: 99,
                divisions: 99,
                label: _currentValue.toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentValue = value.round();
                    _controller.text = _currentValue.toString();
                  });
                },
                onChangeEnd: (double value) {
                  _updateValue(value.round());
                },
              ),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onSubmitted: _onTextChanged,
                onChanged: (text) {
                  // Only update if valid int and in range
                  final val = int.tryParse(text);
                  if (val != null && val >= 0 && val <= 99) {
                    setState(() {
                      _currentValue = val;
                    });
                    widget.onChanged(_currentValue);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final tuple in [
              (-5, Icons.fast_rewind),
              (-1, Icons.remove),
              (0, Icons.refresh),
              (1, Icons.add),
              (5, Icons.fast_forward),
            ])
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ElevatedButton(
                    onPressed: () {
                      if (tuple.$1 == 0) {
                        _updateValue(0);
                      } else {
                        _updateValue(_currentValue + tuple.$1);
                      }
                    },
                    child: Icon(tuple.$2),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
