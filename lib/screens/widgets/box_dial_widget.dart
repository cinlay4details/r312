import 'dart:math';
import 'dart:ui'; // Required for lerpDouble
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hold_down_button/hold_down_button.dart';

class BoxDialWidget extends StatelessWidget {
  const BoxDialWidget({
    required this.value,
    required this.deltaValue, // Channel is optional, super.key,, super.key,
    super.key,
    this.label, // Icon is optional
    this.channel,
  });
  static const int _maxDialValue = 255;
  final String? label;
  final String? channel; // Channel is optional
  final int value;
  final void Function(int) deltaValue;

  @override
  Widget build(BuildContext context) {
    const size = 60.0;
    return Column(
      mainAxisSize:
          MainAxisSize.min, // Ensures the column takes minimal vertical space
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 2,
              child: SvgPicture.asset('assets/swoosh.svg', width: 50),
            ),
            // Dial background with a dark gray outline
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[800]!, // Dark gray outline
                  width: 2,
                ),
              ),
            ),
            // Yellow line at 0 position (7 o'clock)
            Transform.rotate(
              angle: 7 * pi / 6,
              child: Container(
                width: 2, // Thickness of the yellow line
                height: size + 25, // Larger than the dial
                alignment: Alignment.topCenter,
                child: Container(
                  width: 2, // Thickness of the yellow line
                  height: 10, // Small fraction of the length
                  color: Colors.yellow,
                ),
              ),
            ),
            // Yellow line at _maxDialValue position (5 o'clock)
            Transform.rotate(
              angle: 5 * pi / 6,
              child: Container(
                width: 2, // Thickness of the yellow line
                height: size + 25, // Larger than the dial
                alignment: Alignment.topCenter,
                child: Container(
                  width: 2, // Thickness of the yellow line
                  height: 10, // Small fraction of the length
                  color: Colors.yellow,
                ),
              ),
            ),
            // Rotating clock-hand
            Transform.rotate(
              angle:
                  lerpDouble(
                    7 * pi / 6,
                    (12 + 5) * pi / 6,
                    value / _maxDialValue,
                  )!, // Map progress (0-_maxDialValue) to angle
              child: Container(
                width: 5, // Thickness of the yellow line
                height: size, // Full diameter of the circle
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Transparent background
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 5, // Thickness of the yellow line
                    height: size / 2, // Half the diameter (radius)
                    color: Colors.yellow, // Clock-hand color
                  ),
                ),
              ),
            ),
            if (label != null)
              Positioned(
                top: 75,
                child: Center(
                  child: Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: -0.1,
                      height: 0.9,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            // Left button (anticlockwise)
            Positioned(
              left: -5,
              child: HoldDownButton(
                longWait: const Duration(milliseconds: 100),
                middleWait: const Duration(milliseconds: 50),
                minWait: const Duration(milliseconds: 25),
                holdWait: const Duration(milliseconds: 10),
                onHoldDown: () => deltaValue(-1),
                child: IconButton(
                  icon: const Icon(Icons.remove, color: Colors.grey),
                  onPressed: () => {},
                  hoverColor: Colors.grey.shade900.withAlpha(100),
                ),
              ),
            ),
            // Right button (clockwise)
            Positioned(
              right: -5,
              child: HoldDownButton(
                longWait: const Duration(milliseconds: 100),
                middleWait: const Duration(milliseconds: 50),
                minWait: const Duration(milliseconds: 25),
                holdWait: const Duration(milliseconds: 10),
                onHoldDown: () => deltaValue(1),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.grey),
                  onPressed: () => deltaValue(1),
                  hoverColor: Colors.grey.shade900.withAlpha(100),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
