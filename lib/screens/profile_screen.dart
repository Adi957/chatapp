//import 'dart:convert';
//import 'dart:convert';
//import 'dart:developer';
//import 'dart:math';

//import 'dart:math';

import 'dart:developer';
import 'dart:io';

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
import 'package:image_picker/image_picker.dart';

import '../main.dart';

//profile screen to show user info
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard when we tap anyplace at keyboard it gets hide
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              });
            },
            icon: Icon(Icons.add_comment_rounded),
            label: Text('Logout'),
          ),
        ),

        // leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
        body: Form(
          key: _formKey, //provides control over all the text view made by us
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
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
                      //profile picture
                      _image != null
                          ?

                          // local image
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                height: mq.height * .2,
                                width: mq.height * .43,
                                fit: BoxFit.cover,
                              ))
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                height: mq.height * .2,
                                width: mq.width * .43,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),

                      //edit image Button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
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

//name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required field',
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
                  SizedBox(
                    // width: mq.width,
                    height: mq.height * .03,
                  ),

// about input field
                  TextFormField(
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required field',
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.validate();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'profile updated Successfully');
                          });
                        }
                      },
                      icon: Icon(Icons.edit),
                      label: Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//bottom sheet for picking a profile picture for user

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: mq.height * 0.03,
                bottom: mq.height * .02,
                left: mq.width * 0.05),
            children: [
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //adding image adding to the button

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.v
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');

                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          //for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image_button.png')),

                  // adding gallery access button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image Path: ${image.path} ');
                          setState(() {
                            _image = image.path;
                          });
                          //for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/cam_button_chatapp.png')),
                ],
              )
            ],
          );
        });
  }
}
