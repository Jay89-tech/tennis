import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tennis_training_app/controllers/auth_controller.dart';
import 'package:tennis_training_app/views/splash_screen.dart';
import 'package:tennis_training_app/views/login_screen.dart';
import 'package:tennis_training_app/views/register_screen.dart';
import 'package:tennis_training_app/views/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TennisTrainingApp());
}

class TennisTrainingApp extends StatelessWidget {
  const TennisTrainingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthController>(
          create: (_) => AuthController(),
        ),
      ],
      child: MaterialApp(
        title: 'Tennis Training Pro',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          // Add home screen route later
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}