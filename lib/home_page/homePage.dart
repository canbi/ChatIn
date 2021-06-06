import 'dart:ui';

import 'package:chatin/messages/messageScreen.dart';
import 'package:chatin/icons.dart';
import 'package:chatin/models/ChatMessage.dart';
import 'package:chatin/profile_page/profilePage.dart';
import 'package:chatin/settings_page/settingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ChatinFirebaseService.dart';

class HomePage extends StatefulWidget {
  final String nickname;

  const HomePage({Key key, this.nickname}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool refresh;
  final _textFieldController = TextEditingController();
  String newChatroomName;
  bool isOwner;
  @override
  void initState() {
    super.initState();
    refresh = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start ChatIn',
                      //style: TextStyle(fontWeight: FontWeight.bold, fontFeatures: ),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(flex: 10),
                    IconButtons(
                        mainColor: Colors.green,
                        secondColor: Colors.black,
                        icon: Icons.refresh,
                        onPressed: () => setState(() {
                              refresh = !refresh;
                            })),
                    Spacer(flex: 1),
                    IconButtons(
                      mainColor: Colors.blue,
                      secondColor: Colors.red,
                      icon: Icons.settings,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      ),
                    ),
                    Spacer(flex: 1),
                    ProfileIcon(
                        character: widget.nickname[0],
                        onPressed: () => ChatinFirebaseService()
                            .getUserById(widget.nickname)
                            .then(
                              (value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          bio: value.data()["bio"],
                                          nickname: widget.nickname,
                                        )),
                              ),
                            )),
                  ],
                ),
                SizedBox(height: 40),
                FutureBuilder<List<dynamic>>(
                  future: ChatinFirebaseService().getAllChatIds(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: SizedBox(
                          child: GridView.builder(
                            itemCount: snapshot.data.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                            ),
                            itemBuilder: (BuildContext ctx, index) {
                              if (index == 0) {
                                return ChatroomCircle(
                                  mainColor: Colors.blue,
                                  secondColor: Colors.red,
                                  chatroomChar: "+",
                                  chatroomName: "Create Chatroom!",
                                  onPressed: () =>
                                      _displayTextInputDialog(context),
                                );
                              } else {
                                return ChatroomCircle(
                                    mainColor: Colors.red,
                                    secondColor: Colors.blue,
                                    chatroomChar:
                                        "${snapshot.data[index - 1][0].toUpperCase()}",
                                    chatroomName: "${snapshot.data[index - 1]}",
                                    onPressed: () => ChatinFirebaseService()
                                        .getChatroom(
                                            "${snapshot.data[index - 1]}")
                                        .then((value) => setState(() {
                                              isOwner = value.data()["uid"] ==
                                                  widget.nickname;
                                            }))
                                        .then(
                                          (value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MessageScreen(
                                                isOwner: isOwner,
                                                nickname: widget.nickname,
                                                chatroom_name:
                                                    "${snapshot.data[index - 1]}",
                                              ),
                                            ),
                                          ),
                                        ));
                              }
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error");
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Creating a Chatroom'),
          content: TextField(
            onSubmitted: (value) {
              ChatinFirebaseService()
                  .checkIfRoomExists(value)
                  .then((isExist) => isExist
                      ? Navigator.pop(context)
                      : ChatinFirebaseService()
                          .createChatroom(widget.nickname, value)
                          .then((value) => setState(() {
                                newChatroomName = value;
                              }))
                          .then((value) => Navigator.pop(context))
                          .then((value) => _textFieldController.clear())
                          .then(
                            (value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageScreen(
                                    isOwner: true,
                                    nickname: widget.nickname,
                                    chatroom_name: "$newChatroomName"),
                              ),
                            ),
                          ));
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter your chatroom name"),
          ),
        );
      },
    );
  }
}

class ChatroomCircle extends StatelessWidget {
  final String chatroomName;
  final String chatroomChar;
  final Function onPressed;
  final Color mainColor;
  final Color secondColor;

  const ChatroomCircle({
    Key key,
    this.chatroomName,
    this.onPressed,
    this.chatroomChar,
    this.mainColor,
    this.secondColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: mainColor, // Button color
              child: InkWell(
                splashColor: secondColor, // Splash color
                onTap: onPressed,
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Center(
                    child: Text(
                      "$chatroomChar", //"${snapshot.data[index - 1][0].toUpperCase()}",
                      style: TextStyle(color: Colors.white, fontSize: 36),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$chatroomName", //"${snapshot.data[index - 1]}",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
