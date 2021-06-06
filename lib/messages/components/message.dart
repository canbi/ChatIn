import 'package:chatin/constants.dart';
import 'package:chatin/icons.dart';
import 'package:chatin/models/ChatMessage.dart';
import 'package:flutter/material.dart';

import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
    this.user,
  }) : super(key: key);
  final String user;
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) ...[
            ProfileIcon(character: user[0].toUpperCase(), onPressed: () {}),
            SizedBox(width: kDefaultPadding / 2),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isSender) ...[
                Text(" ${user.toLowerCase()}",
                    style: TextStyle(color: Colors.white)),
              ],
              SizedBox(height: 3),
              TextMessage(message: message),
            ],
          ),
        ],
      ),
    );
  }
}
