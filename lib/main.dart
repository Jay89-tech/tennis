import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Services
import 'package:tennis_training_app/services/auth_service.dart';
import 'package:tennis_training_app/services/user_service.dart';
import 'package:tennis_training_app/services/firebase_storage_service.dart';
import 'package:tennis_training_app/services/training_session_service.dart';

// Controllers
import 'package:tennis_training_app/controllers/auth_controller.dart';
import 'package:tennis_training_app/controllers/storage_controller.dart';
import 'package:tennis_training_app/controllers/training_session_controller.dart';

// Views
import 'package:tennis_training_app/views/splash_screen.dart';
import 'package:tennis_training_app/views/login_screen.dart';
import 'package:tennis_training_app/views/register_screen.dart';
import 'package:tennis_training_app/views/forgot_password_screen.dart';
import 'package:tennis_training_app/views/home_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const TennisTrainingApp());
}

class TennisTrainingApp extends StatelessWidget {
  const TennisTrainingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services first
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<UserService>(
          create: (_) => UserService(),
        ),
        Provider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        Provider<TrainingSessionService>(
          create: (_) => TrainingSessionService(),
        ),
        
        // Controllers that depend on services
        Provider<AuthController>(
          create: (context) => AuthController(),
        ),
        Provider<StorageController>(
          create: (context) => StorageController(
            storageService: context.read<FirebaseStorageService>(),
          ),
        ),
        Provider<TrainingSessionController>(
          create: (context) => TrainingSessionController(
            sessionService: context.read<TrainingSessionService>(),
          ),
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
          '/home': (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}