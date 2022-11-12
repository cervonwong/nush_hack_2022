import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'logic/controllers/gates_selected_controller.dart';
import 'ui/pages/welcome_page.dart';
import 'logic/di/injection_container.dart' as injection_container;

void main() {
  injection_container.configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GatesSelectedController>(
          create: (context) => GetIt.instance(),
        ),
      ],
      child: MaterialApp(
        title: 'LiveLaughLogic',
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
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              visualDensity: const VisualDensity(
                vertical: 4.0,
                horizontal: 4.0,
              ),
              foregroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                return const Color(0xFF000000);
              }),
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                return const Color(0xFFFFD233);
              }),
            ),
          ),
        ),
        home: const WelcomePage(),
      ),
    );
  }
}
