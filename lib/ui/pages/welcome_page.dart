import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'challenge_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
                'Learn about logic gates!',
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
                'Logic gates are the fundamental building blocks that '
                'powers our toasters, phones, and even supercomputers. '
                'In this interactive game, try your hands at solving '
                'challenges by building your own logic-gated circuits.',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChallengePage(),
                    ),
                  );
                },
                child: const Text('Start game!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
