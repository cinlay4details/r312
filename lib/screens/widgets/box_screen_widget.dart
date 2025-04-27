import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxScreenWidget extends StatelessWidget {
  const BoxScreenWidget({required this.screenText, super.key});

  final List<String> screenText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16), // Add padding
            child: Container(
              width: 180, // Limit width to 100
              height: 50, // 2 rows * 40px each
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent[400],
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildRow(screenText[0]), _buildRow(screenText[1])],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String text) {
    return Text(
      text.padRight(16).substring(0, 16), // Ensure exactly 16 characters
      style: TextStyle(
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        fontSize: 15,
        height: 1,
        color: Colors.green[900], // Dark green text
      ),
      textAlign: TextAlign.left,
    );
  }
}
