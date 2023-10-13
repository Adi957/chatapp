// //import 'dart:convert';
// //import 'dart:convert';
// //import 'dart:developer';
// //import 'dart:math';

// import 'package:chatapp/api/api.dart';
// import 'package:chatapp/model/chat_user.dart';
// import 'package:chatapp/screens/profile_screen.dart';
// import 'package:chatapp/widgets/_chat_user_card.dart';
// //import 'package:chatapp/widgets/_chat_user_card.dart';
// //import 'package:firebase_auth/firebase_auth.dart';
// //import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     APIs.getSelfInfo();
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       //Making of AppBar
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Icon(CupertinoIcons.home),
//         ),
//         title: Text("Let's Chat"),
//         actions: [
//           IconButton(
//               onPressed: () {}, icon: Icon(Icons.search)), //search user button
//           IconButton(
//               onPressed: () {},
//               icon: Icon(Icons.more_vert)) // more features button
//         ],
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 10.0),
//         child: FloatingActionButton(
//           onPressed: () {},
//           child: Icon(Icons.add_comment_rounded),
//         ),
//       ),
//     );
//   }
// }


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
  //for storing all users
  List<ChatUser> _list = [];
  //for storing searched items
  List<ChatUser> _searchList = [];
// for searching searched status
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            //Making of AppBar
            appBar: AppBar(
              leading: Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email. ....'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      //when search text changes then updated search list
                      onChanged: (val) {
                        //search logic
                        _searchList.clear();

                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                          ;
                        }
                      })
                  : Text("Let's Chat"),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)), //search user button
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
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
                stream: APIs.getAllUser(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
                        });
                  } else {
                    return Center(
                      child: Text('no connection found!',
                          style: TextStyle(fontSize: 20)),
                    );
                  }
                })),
      ),
    );
  }
}
