import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nush_hack_2022/ui/pages/welcome_page.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CongratzPage extends StatelessWidget {
  final _controller = YoutubePlayerController(
    initialVideoId: 'dQw4w9WgXcQ',
    params: YoutubePlayerParams(
      startAt: const Duration(minutes: 0, seconds: 0),
      autoPlay: true,
    ),
  );

  CongratzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24.0),
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
              const SizedBox(height: 16.0),
              YoutubePlayerIFrame(
                controller: _controller,
                aspectRatio: 16 / 9,
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
          )),
        ),
      ),
    );
  }
}
