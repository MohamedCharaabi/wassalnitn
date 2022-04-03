import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/chat_services.dart';
import 'package:wassalni/models/room_model.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';

import '../../../../models/ChatMessage.dart';
import 'chat_input_field.dart';
import 'messages.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    String currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid!;

    return StreamBuilder<RoomModel?>(
        stream: ChatService().getRoom(widget.user.uid!, currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Chat"),
            );
          }

          final chat = snapshot.data!;

          if (chat.messages.isEmpty) {
            return Container(
              color: background,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "First Message",
                        style: TextStyle(
                          fontSize: 18,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                  ChatInputField(
                    onSend: () {
                      log('sending....');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('sending....'),
                        ),
                      );
                    },
                    onChanged: (text) {
                      log(text);
                    },
                  ),
                ],
              ),
            );
          }

          return Container(
            color: background,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: kDefaultPadding),
                    child: ListView.builder(
                      itemCount: demeChatMessages.length,
                      itemBuilder: (context, index) => Message(
                        message: demeChatMessages[index],
                      ),
                    ),
                  ),
                ),
                ChatInputField(
                  onChanged: (val) {},
                ),
              ],
            ),
          );
        });
  }
}
