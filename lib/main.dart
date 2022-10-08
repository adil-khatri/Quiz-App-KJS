import 'package:flutter/material.dart';
import 'package:quiz_app_kjs/Components/Home.dart';
import 'onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAOW4GJLHHHYM-D2l2Z2OG9MJXGQ86-0xs",
            appId: "1:385680169835:ios:7ef730fda489287c9fca2e",
            messagingSenderId: "Your Sender id found in Firebase",
            projectId: "quiz-app-40ae0"));
  } else {
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OnboardingScreen(),
      routes: {
          "/home": (context) => Home_Page(),
          
        },
    );
  }
}
