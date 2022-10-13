import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_kjs/Components/AuthPage.dart';
import 'package:quiz_app_kjs/Components/Authentication.dart';
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
    return MultiProvider(
        providers: [
    Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
          FutureProvider<Map<String, dynamic>?>(
            create: (context) async {
              var user = Provider.of<FirebaseAuthService>(context, listen: false).currentUser();
              var userDoc = await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user!.email)
                  .get();
              return userDoc.data();
            },
            initialData: {},
          ),
        ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthPage(),
        routes: {
            "/home": (context) => Home_Page(),

          },
      ),
    );
  }
}
