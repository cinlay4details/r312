import 'package:flutter/material.dart';
import 'package:r312/models/u312_model_bridge.dart';
import 'package:r312/models/u312_model_direct.dart';
import 'package:r312/models/u312_model_remote.dart';
import 'package:r312/models/u312_model_stub.dart';
import 'package:r312/screens/pages/box_picker.dart';
import 'package:r312/screens/panels/bridge_control_panel.dart';
import 'package:r312/screens/panels/direct_control_panel.dart';
import 'package:r312/screens/panels/remote_control_panel.dart';
import 'package:r312/screens/panels/stub_control_panel.dart';

enum PanelType { stub, remote, bridge, direct }

class BoxListPage extends StatefulWidget {
  const BoxListPage({super.key});

  @override
  State<BoxListPage> createState() => _BoxListPageState();
}

class _BoxListPageState extends State<BoxListPage> {
  final List<dynamic> _panels = []; // Now holds model instances

  void _addPanel(dynamic model) {
    setState(() {
      _panels.add(model);
    });
  }

  void _removePanel(dynamic model) {
    setState(() {
      _panels.remove(model);
    });
  }

  Future<void> _showBoxPicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute<BoxPicker>(
        builder:
            (context) => BoxPicker(
              onPanelPicked: (model) {
                if (model != null) {
                  _addPanel(model);
                  Navigator.of(
                    context,
                  ).pop(); // Close the picker after selection
                }
              },
            ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildPanel(dynamic model) {
    void onRemove() => _removePanel(model);

    if (model is U312ModelStub) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StubControlPanel(model: model, onRemove: onRemove),
        ),
      );
    } else if (model is U312ModelRemote) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RemoteControlPanel(model: model, onRemove: onRemove),
        ),
      );
    } else if (model is U312ModelBridge) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BridgeControlPanel(model: model, onRemove: onRemove),
        ),
      );
    } else if (model is U312ModelDirect) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DirectControlPanel(model: model, onRemove: onRemove),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('r312')),
      body: ListView.builder(
        itemCount: _panels.length + 1,
        itemBuilder: (context, index) {
          if (index < _panels.length) {
            return _buildPanel(_panels[index]);
          }
          // Last item: [+] button
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 48),
                tooltip: 'Add Panel',
                onPressed: _showBoxPicker,
              ),
            ),
          );
        },
      ),
    );
  }
}
