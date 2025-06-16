import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r312/screens/box_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r312',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.yellow,
          secondary: Colors.yellow,
          surface: Colors.grey[850]!,
        ),
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const BoxPicker(),
    );
  }
}
