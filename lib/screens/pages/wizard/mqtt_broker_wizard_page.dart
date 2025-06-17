import 'package:flutter/material.dart';

class MqttBrokerWizardPage extends StatefulWidget {
  const MqttBrokerWizardPage({required this.onSelect, super.key});

  final void Function(String) onSelect;

  @override
  State<MqttBrokerWizardPage> createState() => _MqttBrokerWizardPage();
}

class _MqttBrokerWizardPage extends State<MqttBrokerWizardPage> {
  String? _mqttBrokerAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Enter MQTT Broker Address',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Format: [protocol]://([username]:[password]@)?mqtt-location//topic',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'MQTT Broker Address',
            ),
            onChanged: (value) {
              setState(() {
                _mqttBrokerAddress = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed:
                _mqttBrokerAddress != null && _mqttBrokerAddress!.isNotEmpty
                    ? () => widget.onSelect(_mqttBrokerAddress!)
                    : null,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
