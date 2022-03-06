import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/modelView/services/chat_services.dart';
import 'package:wassalni/models/Chat.dart';
import 'package:wassalni/models/chat_model.dart';
import 'package:wassalni/utils/constants.dart';
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
    String userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid!;

    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: _chatService.getUserChats(userId),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting ||
                !snapshots.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final chats = snapshots.data!.docs
                .map((e) =>
                    ChatModel.fromMap(e.data() as Map<String, dynamic>, e.id))
                .toList();

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) => ChatCard(
                        chat: chatsData[index],
                        press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessagesScreen(),
                            )),
                      )),
            );
          }),
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

  final Chat chat;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: InkWell(
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(chat.image),
                  ),
                  if (chat.isActive)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                            color: mainColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 3)),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: white),
                        ),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          chat.time,
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
  }
}
