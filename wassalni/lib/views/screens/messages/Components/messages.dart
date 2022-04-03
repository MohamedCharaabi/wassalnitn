import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/models/ChatMessage.dart';
import 'package:wassalni/models/message_model.dart';
import 'package:wassalni/utils/constants.dart';

import 'text_message.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid!;

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: message.sender == currentUserId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.sender != currentUserId) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: white,
              // backgroundImage: AssetImage('assets/images/user.png'),
            ),
            const SizedBox(
              width: kDefaultPadding / 2,
            )
          ],
          TextMessage(
            message: message,
          ),
          // if (message.isSender) MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus status;

  const MessageStatusDot({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: mainColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Colors.white,
      ),
    );
  }
}
