import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workout_fitness/view/menu/menu_view.dart';

import 'common/color_extension.dart';

Future<void> main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // Firebase initialization for web
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAPe2PfnC4XLCSVchfPa_ujggdpHHForPY",
          authDomain: "fitnessapp2-b305f.firebaseapp.com",
          projectId: "fitnessapp2-b305f",
          storageBucket: "fitnessapp2-b305f.appspot.com",
          messagingSenderId: "371366875862",
          appId: "1:371366875862:web:37a8c848a7bded1a3b2f77",
        ),
      );
    } else {
      // Firebase initialization for mobile
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Log any initialization errors
    debugPrint("Error initializing Firebase: $e");
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Quicksand",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
        ),
        useMaterial3: true, // Enables modern Material3 design
      ),
      home: const MenuView(),
    );
  }
}
