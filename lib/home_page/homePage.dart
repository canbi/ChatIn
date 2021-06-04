import 'package:chatin/messages/messageScreen.dart';
import 'package:chatin/profileIcon.dart';
import 'package:flutter/material.dart';

final List<Map> chatRooms =
    List.generate(4, (index) => {"id": index, "name": "Chatroom #${index + 1}"}).toList();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WelcomePart(),
              SizedBox(height: 40),
              ChatroomList(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatroomList extends StatelessWidget {
  const ChatroomList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("chatroomlist");
    return Expanded(
      child: SizedBox(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20,
          ),
          itemCount: chatRooms.length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          chatroom_id: chatRooms[index]["id"],
                          chatroom_name: chatRooms[index]["name"],
                        ),
                      ),
                    ),
                    child: CircleAvatar(backgroundColor: Colors.redAccent, minRadius: 42),
                  ),
                  SizedBox(height: 8),
                  Text(
                    chatRooms[index]["name"],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class WelcomePart extends StatelessWidget {
  const WelcomePart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Start ChatIn',
          //style: TextStyle(fontWeight: FontWeight.bold, fontFeatures: ),
          style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold),
        ),
        ProfileIcon(onPressed: () {})
      ],
    );
  }
}
