import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/chat_services.dart';
import 'package:wassalni/models/ChatMessage.dart';
import 'package:wassalni/models/message_model.dart';
import 'package:wassalni/models/room_model.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/views/screens/messages/Components/body.dart';
import 'package:wassalni/views/screens/messages/Components/chat_input_field.dart';
import 'package:wassalni/views/screens/messages/Components/messages.dart';

class MessagesScreen extends StatefulWidget {
  final UserModel user;

  const MessagesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  ValueNotifier<String> message = ValueNotifier<String>('');

  final searchController = TextEditingController();
  final messagesScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    String currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid!;

    List<String> users = [];
    users.add(currentUserId);
    users.add(widget.user.uid!);
    users.sort();
    Responsive _responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: white,
              // backgroundImage:
              //     user.image != null ? NetworkImage(user.image!) : null
              //  const AssetImage(  "assets/images/user.png"),
            ),
            const SizedBox(
              width: kDefaultPadding * 0.75,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name!,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: _responsive.height - kToolbarHeight,
        width: _responsive.width,
        child: Stack(
          children: [
            StreamBuilder<RoomModel?>(
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
                      child: Center(
                        child: Text(
                          "First Message",
                          style: TextStyle(
                            fontSize: 18,
                            color: white,
                          ),
                        ),
                      ),
                    );
                  }

                  //  messages  > 0

                  return Container(
                    height: _responsive.height -
                        kToolbarHeight -
                        _responsive.height * 0.15,
                    color: background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding),
                      child: ListView.builder(
                        controller: messagesScrollController,
                        shrinkWrap: true,
                        itemCount: chat.messages.length,
                        itemBuilder: (context, index) => Message(
                          message: chat.messages[index],
                        ),
                      ),
                    ),
                  );
                }),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: _responsive.height * 0.15,
                width: _responsive.width,
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
                                child: TextFormField(
                                  controller: searchController,
                                  onChanged: (val) {
                                    message.value = val;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ValueListenableBuilder<String>(
                          valueListenable: message,
                          builder: (context, value, _) {
                            return IconButton(
                                onPressed: () async {
                                  if (value.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('search is empty')));

                                    return;
                                  }

                                  final result =
                                      await ChatService().sendMessage(
                                    userId: currentUserId,
                                    receiverId: widget.user.uid!,
                                    message: value,
                                  );
                                  // close keyboard
                                  FocusScope.of(context).unfocus();
                                  message.value = '';
                                  searchController.clear();
                                  messagesScrollController.animateTo(
                                    1,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                icon: const Icon(Icons.send),
                                color: white);
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(String name, String image) {
    return AppBar(
      backgroundColor: mainColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/user.png"),
          ),
          SizedBox(
            width: kDefaultPadding * 0.75,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "kristin Watson",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
