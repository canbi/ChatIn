import 'package:chatin/ChatinFirebaseService.dart';
import 'package:chatin/home_page/homePage.dart';
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
            ClipOval(
              child: Material(
                color: Colors.red, // Button color
                child: InkWell(
                  onTap: () => ChatinFirebaseService()
                      .removeChatroom(widget.nickname, widget.chatroom_name)
                      .then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              nickname: widget.nickname,
                            ),
                          ),
                        ),
                      ),
                  splashColor: Colors.blue, // Splash color
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        "X",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
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
