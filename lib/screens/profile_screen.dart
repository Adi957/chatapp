//import 'dart:convert';
//import 'dart:convert';
//import 'dart:developer';
//import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/api.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
//import 'package:chatapp/widgets/_chat_user_card.dart';
//import 'package:chatapp/widgets/_chat_user_card.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

//profile screen to show user info
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Making of AppBar
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                //for hiding progress dialog
                Navigator.pop(context);

                //for moving to home screen
                Navigator.pop(context);

                //replacing home screen with login screen
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              });
            });
          },
          icon: Icon(Icons.add_comment_rounded),
          label: Text('Logout'),
        ),
      ),

      // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
        child: Column(
          children: [
            //For adding Some space
            SizedBox(
              width: mq.width,
              height: mq.height * .03,
            ),

            //user profile picture
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .2,
                    width: mq.width * .43,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                //edit image Button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    elevation: 1,
                    onPressed: () {},
                    shape: CircleBorder(),
                    color: Colors.white,
                    child: Icon(Icons.edit),
                  ),
                )
              ],
            ),

            SizedBox(
              // width: mq.width,
              height: mq.height * .03,
            ),
            Text(
              widget.user.email,
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),

            //for adding some space
            SizedBox(
              // width: mq.width,
              height: mq.height * .05,
            ),

            TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg. Happy Singh',
                  label: Text('Name')),
            ),

            TextFormField(
              initialValue: widget.user.about,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'eg. Feeling Great',
                  label: Text('About')),
            ),
            SizedBox(
              // width: mq.width,
              height: mq.height * .05,
            ),

            //UPDATE PROFILE BUTTON
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06)),
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: Text(
                  'UPDATE',
                  style: TextStyle(fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
