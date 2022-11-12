import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nush_hack_2022/ui/pages/welcome_page.dart';

class CongratzPage extends StatelessWidget {
  const CongratzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  textStyle: const TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 64.0),
              Text(
                'You have completed the six logic gate challenges, and are now '
                'qualified to be an electrical engineer or something idk.',
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 88.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePage(),
                    ),
                  );
                },
                child: const Text('Return to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
