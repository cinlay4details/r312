import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BorderedText(
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
    );
  }
}
