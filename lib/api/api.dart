import 'dart:developer';
import 'dart:io';

import 'package:chatapp/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

// for accessing cloud firebase database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// for accessing cloud firestore database
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for storing self information
  static late ChatUser me;

//to return current user
  static User get user => auth.currentUser!;

//for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
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

  //for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return APIs.firestore
        .collection('users')
        .where("id",
            isNotEqualTo: user
                .uid) //for excluding our own id, because we can't chat with that.
        .snapshots();
  }

//for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'images/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  /** Chat Screen Related APIs */

  //useful for getting conversation id

  static getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //chats (collection) --> conversation_id (doc) --> message (doc)

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message  to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref =
        firestore.collection('chats/${getConversationID(user.uid)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
