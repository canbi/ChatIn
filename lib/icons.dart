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

class SettingsIcon extends StatelessWidget {
  final Function onPressed;

  const SettingsIcon({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.blue, // Button color
        child: InkWell(
          splashColor: Colors.red, // Splash color
          onTap: onPressed,
          child: SizedBox(width: 40, height: 40, child: Icon(Icons.settings)),
        ),
      ),
    );
  }
}
