import 'package:chatin/constants.dart';
import 'package:chatin/models/ChatMessage.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          new BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: message.isSender
              ? Colors.white
              : Theme.of(context).textTheme.bodyText1.color,
        ),
      ),
    );
  }
}
