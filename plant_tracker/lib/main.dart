import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Required for Firebase
import 'login_screen.dart';

void main() async {
  // 1. Ensures Flutter widgets are ready before Firebase starts
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initializes Firebase using the google-services.json you added
  await Firebase.initializeApp();

  runApp(const FactoryApp());
}

class FactoryApp extends StatelessWidget {
  const FactoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factory Management',
      theme: ThemeData(
        useMaterial3: true,
        // Using your Sona Pepcee green theme
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
      ),
      // Starts the app at the Login Screen with the Admin/Worker toggle
      home: const LoginScreen(),
    );
  }
}