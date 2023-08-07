//import 'package:chatapp/screens/auth/login_screen.dart';
//import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'firebase_options.dart';
//import 'dart:js_interop';

late Size mq; //global object for accessing device screen size

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //with Firebase
// connecting with firebase
  await _initializeFirebase();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

//void _initializeFirebase() {}
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          "Let's Chat", // shows lets chat app in background i.e recent app me
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
          backgroundColor: Colors.blue,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
