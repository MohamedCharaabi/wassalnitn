import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key? key,
    required this.onChanged,
    this.onSend,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final VoidCallback? onSend;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => log('chi'),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: mainColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.75),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: widget.onChanged,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: white.withOpacity(0.64),
                    ),
                    const SizedBox(width: kDefaultPadding / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: white.withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  log('hi');
                },
                icon: const Icon(Icons.send),
                color: white),
          ],
        ),
      ),
    );
  }
}
