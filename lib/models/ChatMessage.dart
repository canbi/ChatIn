import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({
    this.text,
    @required this.isSender,
  });
}
