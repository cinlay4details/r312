import 'package:flutter/material.dart';

class BoxLightWidget extends StatelessWidget {
  // Brightness value (0.0 to 1.0)

  const BoxLightWidget({
    required this.brightness,
    super.key,
    this.icon, // Icon is optional
    this.channel, // Channel is optional
  });
  final IconData? icon; // Icon is optional
  final String? channel; // Channel is optional
  final double brightness;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            if (icon != null) // Render the icon only if it's provided
              Icon(
                icon,
                size: 20,
                color: Colors.yellow, // Adjust opacity based on brightness
                weight: 100,
              ),
            if (icon != null)
              const SizedBox(width: 5), // Add spacing only if the icon exists
            if (icon == null)
              const SizedBox(width: 20), // Placeholder space for alignment
            Container(
              width: 10, // Fixed circle size
              height: 10, // Fixed circle size
              decoration: BoxDecoration(
                color: Colors.amber.withValues(
                  alpha: brightness,
                ), // Adjust opacity based on brightness
                shape: BoxShape.circle, // Make it a circle
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
        if (channel != null) // Render the channel text only if it's provided
          Positioned(
            top: 15,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                const Text(
                  'Ch ',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  channel!,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
