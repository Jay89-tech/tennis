// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TennisTrainingApp());
}

class TennisTrainingApp extends StatelessWidget {
  const TennisTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        title: 'Tennis Training App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF1B5E20), // Professional dark green
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}