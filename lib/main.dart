import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color(0xFFFFFCF0),
        canvasColor: Color(0xFFFFFCF0),
        textTheme: GoogleFonts.firaSansTextTheme(),
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
              GoogleFonts.firaSans(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(0.0),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            visualDensity: const VisualDensity(
              vertical: 4.0,
              horizontal: 4.0,
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return const Color(0xFF000000);
            }),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return const Color(0xFFFFD233);
            }),
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
