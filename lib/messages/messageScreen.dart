import 'package:chatin/profileIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatin/constants.dart';

import 'components/body.dart';

class MessageScreen extends StatelessWidget {
  final int chatroom_id;
  final String chatroom_name;

  const MessageScreen({Key key, this.chatroom_id, this.chatroom_name}) : super(key: key);

  //final chatRef = FirebaseFirestore.instance.collection(collectionPath)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Body(chatroom_id: chatroom_id),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(),
          Text(
            "$chatroom_name",
            style: TextStyle(fontSize: 24),
          ),
          CircleAvatar(
            backgroundColor: Colors.lightGreenAccent,
            //backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
        ],
      ),
    );
  }
}
