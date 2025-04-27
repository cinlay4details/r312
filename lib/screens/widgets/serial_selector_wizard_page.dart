import 'package:flutter/material.dart';

class SerialSelectorWizardPage extends StatelessWidget {
  const SerialSelectorWizardPage({
    required this.devices,
    required this.onSelect, super.key,
  });

  final List<({String address, String name})> devices;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Select your 312 box from this list',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Centered text
              ),
              SizedBox(height: 8),
              Text(
                '''
If you cannot find your box, make sure that it is freshly powered on and connected via bluetooth.

If there are multiple likely devices, prefer one that includes "tty".
''',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center, // Centered text
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return Center(
                child: ListTile(
                  title: Text(devices[index].name, textAlign: TextAlign.center),
                  onTap: () => onSelect(devices[index].address),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
