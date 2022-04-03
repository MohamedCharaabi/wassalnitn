import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/chat_services.dart';
import 'package:wassalni/modelView/services/firebase_crud.dart';
import 'package:wassalni/modelView/user_crud.dart';
import 'package:wassalni/models/Chat.dart';
import 'package:wassalni/models/chat_model.dart';
import 'package:wassalni/models/room_model.dart';
import 'package:wassalni/models/user_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:wassalni/utils/responsive.dart';
import 'package:wassalni/views/client/home/screens/chat_search.dart';
import '../../../utils/filled_outline_button.dart';
import 'message_screen.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser!;
    Responsive _responsive = Responsive(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // search bar only for driver
          currentUser.isDriver!
              ? Container(
                  height: kToolbarHeight,
                  color: mainColor,
                  child: Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatSearch(
                                      searchForDriver:
                                          !currentUser.isDriver!)));
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox(),

          // latest messages rooms

          SingleChildScrollView(
            child: SizedBox(
              height: _responsive.height - kToolbarHeight,
              child: StreamBuilder<List<RoomModel>>(
                  stream: _chatService.getUserChatsRooms(currentUser.uid!),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting ||
                        !snapshots.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final chats = snapshots.data!;

                    log('chats length ${chats.length}');

                    return SizedBox(
                      height: _responsive.height - kToolbarHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) =>
                            chats[index].messages.isNotEmpty
                                ? ChatCard(
                                    chat: chats[index],
                                    press: () {},
                                    // press: () => Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => MessagesScreen(
                                    //         user: chats[index].users.firstWhere(
                                    //             (element) =>
                                    //                 element != currentUser.uid!),
                                    //       ),
                                    //     )),
                                  )
                                : const SizedBox(),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: mainColor,
      automaticallyImplyLeading: false,
      title: const Text("Messages"),
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.message),
          onPressed: () {},
        )
      ],
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
    required this.chat,
    required this.press,
  }) : super(key: key);
  final RoomModel chat;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser!;
    Responsive _responsive = Responsive(context);

    return FutureBuilder<UserModel?>(
        future: FirebaseCrud().getUserInfo(
            chat.users.firstWhere((element) => element != currentUser.uid!)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('dataNotFound'),
            );
          }

          final user = snapshot.data!;

          return Container(
            color: background,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagesScreen(user: user)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding * 0.75),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: white,
                          // backgroundImage: AssetImage(chat.image),
                        ),
                        // if (chat.isActive)
                        //   Positioned(
                        //     right: 0,
                        //     bottom: 0,
                        //     child: Container(
                        //       height: 16,
                        //       width: 16,
                        //       decoration: BoxDecoration(
                        //           color: mainColor,
                        //           shape: BoxShape.circle,
                        //           border: Border.all(
                        //               color:
                        //                   Theme.of(context).scaffoldBackgroundColor,
                        //               width: 3)),
                        //     ),
                        //   )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'no name',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                chat.messages.isNotEmpty
                                    ? chat.messages.last.message
                                    : '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                DateFormat('HH:mm')
                                    .format(DateTime.parse(chat.createAt)),
                                style: TextStyle(color: white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    /* Todo Message seen?? */
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: Color(0xFFF95008),
                          shape: BoxShape.circle,
                          border: Border.all(width: 3)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
