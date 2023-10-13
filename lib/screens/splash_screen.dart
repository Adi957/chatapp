//import 'dart:html';

//import 'dart:developer';

import 'dart:developer';

import 'package:chatapp/api/api.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:chatapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

//splash screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //init state is used for only once in the app , example for using the app first time
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        //navigate to home screen
        log('\nUser: ${APIs.auth.currentUser}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to Let's Chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .50,
              duration: Duration(seconds: 1),
              child: Image.asset('images/icon.png.png')),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: Text(
              'MADE IN INDIA WITH ❤️',
              style: TextStyle(fontSize: 16, letterSpacing: .5),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
