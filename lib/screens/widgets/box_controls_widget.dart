import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:r312/screens/widgets/box_button_widget.dart';

class BoxControlsWidget extends StatelessWidget {
  const BoxControlsWidget({
    required this.disconnectPressed,
    required this.leftPressed,
    required this.rightPressed,
    super.key,
  });

  final VoidCallback disconnectPressed;
  final VoidCallback leftPressed;
  final VoidCallback rightPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxButtonWidget(icon: Icons.chevron_left, onPressed: leftPressed),
              BoxButtonWidget(
                icon: Icons.link_off,
                onPressed: disconnectPressed,
              ),
              BoxButtonWidget(
                icon: Icons.chevron_right,
                onPressed: rightPressed,
              ),
            ],
          ),
          const SizedBox(height: 10), // Spacing between rows
          BorderedText(
            strokeColor: Colors.yellow,
            strokeWidth: 2,
            child: const Text(
              'r312',
              style: TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
