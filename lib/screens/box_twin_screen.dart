import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:r312/models/u312_model_stub.dart';
import 'package:r312/screens/widgets/box_controls_widget.dart';
import 'package:r312/screens/widgets/box_dial_widget.dart';
import 'package:r312/screens/widgets/box_light_widget.dart';
import 'package:r312/screens/widgets/box_screen_widget.dart';

class BoxTwinWidget extends StatelessWidget {
  const BoxTwinWidget({
    required this.appState,
    super.key,
  });

  final U312ModelStub appState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState, // Listen to changes in appState
      builder: (context, child) {
        return Scaffold(
          backgroundColor:
              Colors.grey[900], // Set the background color to dark gray
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20), // Padding outside the border
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                ), // Limit max width to 600
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Black background
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ), // White border
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                  ),
                  padding: const EdgeInsets.all(
                    16,
                  ), // Padding inside the container
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Shrink to fit content
                    children: [
                      Row(
                        children: [
                          BoxLightWidget(
                            icon: Symbols.battery_charging_full,
                            brightness: appState.battery,
                          ),
                          BoxDialWidget(
                            value: appState.multiAdjustDial,
                            label: 'Multi\nAdjust',
                            deltaValue: (value) {
                              appState.multiAdjustDial += value;
                            },
                          ),
                          BoxScreenWidget(screenText: appState.screenText),
                          BoxDialWidget(
                            value: appState.chADial,
                            deltaValue: (value) {
                              appState.chADial += value;
                            },
                          ),
                          BoxLightWidget(
                            brightness: appState.chA,
                            channel: 'A',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Spacing between rows
                      Row(
                        children: [
                          BoxLightWidget(
                            icon: Symbols.power_settings_new,
                            brightness: appState.power,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Spacing between rows
                      Row(
                        children: [
                          BoxLightWidget(
                            icon: Symbols.volume_up,
                            brightness: appState.volume,
                          ),
                          BoxDialWidget(
                            value: appState.aAndBDial,
                            label: 'A & B',
                            deltaValue: (value) {
                              appState.aAndBDial += value;
                            },
                          ),
                          BoxControlsWidget(
                            leftPressed: appState.pressLeft,
                            rightPressed: appState.pressRight,
                            disconnectPressed: () async {
                              await appState.pressDisconnect();
                              Navigator.pop(context);
                            },
                          ),
                          BoxDialWidget(
                            value: appState.chBDial,
                            deltaValue: (value) {
                              appState.chBDial += value;
                            },
                          ),
                          BoxLightWidget(
                            brightness: appState.chB,
                            channel: 'B',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
