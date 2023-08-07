import 'package:chatapp/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

// for accessing cloud firebase database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

//to return current user
  static User get user => auth.currentUser!;

//for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }
 
  //for creating a new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        createdAt: time,
        email: user.email.toString(),
        image: user.photoURL.toString(),
        about: "Hey, there Let's Chat 😉",
        isOnline: false,
        lastActive: time,
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
