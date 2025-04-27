import 'package:flutter/material.dart';

class BoxButtonWidget extends StatelessWidget {

  const BoxButtonWidget({
    required this.onPressed, super.key,
    this.text,
    this.icon,
  }) : assert(
    text != null || icon != null,
    'Either text or icon must be provided',
  );
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3), // Add padding around the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          side: const BorderSide(color: Colors.yellow, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Square shape
          ),
          fixedSize: const Size(50, 50), // Square size
          padding: EdgeInsets.zero, // Remove internal padding
        ),
        child: text != null
            ? Text(
                text!,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w200, // Light font weight
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
      ),
    );
  }
}
