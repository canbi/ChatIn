import 'package:chatin/ChatinFirebaseService.dart';
import 'package:chatin/home_page/homePage.dart';
import 'package:chatin/icons.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class MessageScreen extends StatefulWidget {
  final String chatroom_name;
  final String nickname;
  final bool isOwner;

  const MessageScreen(
      {Key key, this.chatroom_name, this.nickname, this.isOwner})
      : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Body(
          chatroom_name: widget.chatroom_name,
          nickname: widget.nickname,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          BackButton(),
          Spacer(flex: 10),
          Text(
            "${widget.chatroom_name}",
            style: TextStyle(fontSize: 24),
          ),
          if (widget.isOwner) ...[
            Spacer(flex: 6),
            IconButtons(
              mainColor: Colors.red,
              secondColor: Colors.blue,
              icon: Icons.delete_forever,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    nickname: widget.nickname,
                  ),
                ),
              ),
            ),
            Spacer(flex: 3),
          ] else
            Spacer(flex: 10),
          ClipOval(
            child: Material(
              color: Colors.blue, // Button color
              child: InkWell(
                onTap: () {},
                splashColor: Colors.red, // Splash color
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Text(
                      "${widget.chatroom_name[0].toUpperCase()}",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
