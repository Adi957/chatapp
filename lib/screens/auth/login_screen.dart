//import 'dart:html';

//import 'dart:math';

import 'dart:developer';
import 'dart:io';

import 'package:chatapp/api/api.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    //init state is used for only once in the app , example for using the app first time
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      log('\nUser: ${user?.user}');
      log('\nUserAdditionalInfo:${user!.additionalUserInfo}');

      if ((await APIs.userExists())) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const HomeScreen())); //if user exists move to homescreen
      } else {
        await APIs.createUser().then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
              //if user does not exits make a user then move to HomeScreen
        });
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');

      Dialogs.showSnackbar(context, 'Something went wrong (check Internet!)');
    }
    ;
    return null;
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
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .50,
              duration: Duration(seconds: 1),
              child: Image.asset('images/icon.png.png')),

          //google login button
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .90,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 151, 241, 129),
                      shape: StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  icon: Image.asset(
                    'images/google.png',
                    height: mq.height * .03,
                  ),
                  label: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(text: 'Login with'),
                        TextSpan(
                            text: ' Google',
                            style: TextStyle(fontWeight: FontWeight.w500))
                      ])))),
        ],
      ),
    );
  }
}
