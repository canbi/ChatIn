import 'package:chatin/ChatinFirebaseService.dart';
import 'package:chatin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatin/models/ChatMessage.dart';
import 'message.dart';

class Body extends StatefulWidget {
  final String chatroom_name;
  final String nickname;

  const Body({Key key, this.chatroom_name, this.nickname}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: ChatinFirebaseService()
                  .getChatroomStream(widget.chatroom_name),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data["messages"].length,
                  itemBuilder: (context, index) => Message(
                    message: ChatMessage(
                        text: snapshot.data["messages"][index]["content"],
                        isSender: snapshot.data["messages"][index]["uid"] ==
                                widget.nickname
                            ? true
                            : false),
                    user: snapshot.data["messages"][index]["uid"],
                  ),
                  //buildItem(context, snapshot.data.documents[index]),
                );
              },
            ),
          ),
        ),
        //textfield
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 32,
                color: Color(0xFF087949).withOpacity(0.08),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.64),
                        ),
                        SizedBox(width: kDefaultPadding / 4),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (value) => ChatinFirebaseService()
                                .sendMessage(widget.nickname,
                                    widget.chatroom_name, value)
                                .then((value) => _textController.clear()),
                            decoration: InputDecoration(
                              hintText: "Type message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: kDefaultPadding / 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
