//import 'dart:convert';
//import 'dart:convert';
//import 'dart:developer';
//import 'dart:math';

import 'package:chatapp/api/api.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/widgets/_chat_user_card.dart';
//import 'package:chatapp/widgets/_chat_user_card.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Making of AppBar
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.home),
          ),
          title: Text("Let's Chat"),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.search)), //search user button
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => ProfileScreen(user: list[0])));
                },
                icon: Icon(Icons.more_vert)) // more features button
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: Icon(Icons.add_comment_rounded),
          ),
        ),
        body: StreamBuilder(
            stream: APIs.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                //if some or all data is loaded then show it

                case ConnectionState.active:
                case ConnectionState.done:
              }

              final data = snapshot.data?.docs;
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                    });
              } else {
                return Center(
                  child: Text('no connection found!',
                      style: TextStyle(fontSize: 20)),
                );
              }
            }));
  }
}
