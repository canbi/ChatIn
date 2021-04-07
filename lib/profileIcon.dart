import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final Function onPressed;

  const ProfileIcon({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.pink.shade200,
        // TODO Buraya kullanıcının görseli gelecek
        //backgroundImage: AssetImage("assets/images/user.png"),
      ),
    );
  }
}
