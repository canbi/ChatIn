import 'package:chatin/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ChatinFirebaseService.dart';

class ProfilePage extends StatefulWidget {
  final String nickname;
  final String bio;

  const ProfilePage({Key key, this.nickname, this.bio}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _textFieldController = TextEditingController();
  String about;

  @override
  void initState() {
    super.initState();
    about = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              BackButton(),
              Center(
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "assets/images/profile-background.jpg"),
                        fit: BoxFit.cover)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0, 2.5),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: SizedBox.expand(
                          child: Center(
                              child: Text(
                        widget.nickname[0].toUpperCase(),
                        style: TextStyle(fontSize: 48, color: Colors.white),
                      ))),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              Flexible(
                child: Text(
                  "${widget.nickname}",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _displayTextInputDialog(context),
                child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    elevation: 2.0,
                    color: Colors.redAccent,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        child: Text(
                          "About",
                          style: TextStyle(
                              letterSpacing: 2.0, fontWeight: FontWeight.w300),
                        ))),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "$about",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Bio'),
          content: TextField(
            onSubmitted: (value) {
              ChatinFirebaseService()
                  .editUser(widget.nickname, widget.nickname, value)
                  .then((value2) => setState(() {
                        about = value;
                      }))
                  .then(
                    (value) => Navigator.pop(context),

                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                bio: about,
                                nickname: widget.nickname,
                              )),
                    ),*/
                  )
                  .then((value) => _textFieldController.clear());
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter your bio"),
          ),
        );
      },
    );
  }
}
