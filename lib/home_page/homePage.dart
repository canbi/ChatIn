import 'package:chatin/messages/messageScreen.dart';
import 'package:chatin/profileIcon.dart';
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
  bool isPublic;

  @override
  void initState() {
    super.initState();
    isPublic = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // TODO
      onWillPop: () async => true,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(bottom: 0, left: 20, right: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start ChatIn',
                      //style: TextStyle(fontWeight: FontWeight.bold, fontFeatures: ),
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      padding: EdgeInsets.all(20),
                      color: Colors.lightGreen,
                      minWidth: MediaQuery.of(context).size.width / 3,
                      onPressed: () {
                        setState(() {
                          isPublic = !isPublic;
                        });
                      },
                      child: Text(
                        isPublic ? "Publis CRs" : "Subsribed CRs",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ProfileIcon(onPressed: () {})
                  ],
                ),
                SizedBox(height: 40),
                FutureBuilder<List<dynamic>>(
                  future: ChatinFirebaseService().getAllChatIds(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length != 0) {
                      return Expanded(
                        child: SizedBox(
                          child: GridView.builder(
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                            ),
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
                                            chatroom_name: //snapshot
                                                "${snapshot.data[index]}",
                                          ),
                                        ),
                                      ),
                                      child: CircleAvatar(
                                          backgroundColor: Colors.redAccent,
                                          minRadius: 42),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "${snapshot.data[index]}",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );

                      /*itemBuilder: (context, index) {
                            return Text("${snapshot.data[index].season_name}");
                          });*/
                    } else if (snapshot.hasError) {
                      return Text("Error");
                    }
                    return Text("Loading...");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatroomList extends StatelessWidget {
  final List<Map> chatRooms;
  const ChatroomList({
    Key key,
    this.chatRooms,
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
                          chatroom_name: chatRooms[index]["name"],
                        ),
                      ),
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.redAccent, minRadius: 42),
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
