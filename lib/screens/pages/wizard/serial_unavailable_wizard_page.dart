import 'package:flutter/material.dart';

class SerialUnavailableWizardPage extends StatelessWidget {
  const SerialUnavailableWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          '''
You cannot use this device to directly control a 312.

This is likely because you are using a web browser that does not support the Web Serial API.
Currently only Chrome and Edge on desktop support this.

If you are using the android app, please check that you have the correct permissions set.
''',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
