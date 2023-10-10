import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/api.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/model/chat_user.dart';
import 'package:chatapp/model/message.dart';
import 'package:chatapp/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//for storing all messages
  List<Message> _list = [];

//for handling message text changes
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();

                  //if some or all data is loaded then show it

                  case ConnectionState.active:
                  case ConnectionState.done:
                    //}

                    final data = snapshot.data?.docs;
                    log('Data: ${jsonEncode(data![0].data())}' as num);
                    _list =
                        data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];

                    //final _list = ['hii', 'hello'];
                    // _list.clear();
                    // _list.add(Message(
                    //     toId: 'xyz',
                    //     msg: 'hii',
                    //     read: '',
                    //     type: Type.text,
                    //     fromId: APIs.user.uid,
                    //     sent: '12:00'));

                    // _list.add(Message(
                    //     toId: APIs.user.uid,
                    //     msg: 'hello',
                    //     read: '',
                    //     type: Type.text,
                    //     fromId: APIs.user.uid,
                    //     sent: '12:05'));

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: _list[index],
                            );
                          });
                    } else {
                      return Center(
                        child:
                            Text('Say Hii! 👋', style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
          ),
          _chatInput()
        ],
      ),
    ));
  }

  Widget _appBar() {
    return InkWell(
      child: Row(
        children: [
          //back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),

          //user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              height: mq.height * .055,
              width: mq.width * .055,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "Last seen not available",
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }

//  bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * 0.3),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  //emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
