import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final Function onPressed;
  final String character;

  const ProfileIcon({Key key, this.onPressed, this.character})
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
              width: 40,
              height: 40,
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
