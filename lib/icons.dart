import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final Function onPressed;
  final String character;
  final double width;

  const ProfileIcon({Key key, this.onPressed, this.character, this.width = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.red, // Button color
        child: InkWell(
          splashColor: Colors.blue, // Splash color
          onTap: onPressed,
          child: SizedBox(
              width: width,
              height: width,
              child: Center(child: Text(character.toUpperCase()))),
        ),
      ),
    );
  }
}

class IconButtons extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color mainColor;
  final Color secondColor;

  const IconButtons(
      {Key key, this.onPressed, this.icon, this.mainColor, this.secondColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: mainColor, // Button color
        child: InkWell(
          splashColor: secondColor, // Splash color
          onTap: onPressed,
          child: SizedBox(width: 40, height: 40, child: Icon(icon)),
        ),
      ),
    );
  }
}
