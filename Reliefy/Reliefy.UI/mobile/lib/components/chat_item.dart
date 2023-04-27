import 'package:flutter/material.dart';

import '../utils/constant.dart';

class ChatItem extends StatelessWidget {
  final String content;
  final bool isOwner;
  const ChatItem({super.key, required this.content, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (isOwner ? Alignment.topRight : Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (isOwner ? kPowderBlueColor : Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            content,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
