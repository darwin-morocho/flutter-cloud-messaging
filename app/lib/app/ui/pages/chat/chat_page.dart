import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final int chatId;
  const ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Chat $chatId"),
      ),
    );
  }
}
