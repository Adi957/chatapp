import 'package:chatapp/screens/auth/logic_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//global object for accessing device screen size

late Size mq;

void main() {
  runApp(const MyApp());
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
      home: LogicScreen(),
      //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
