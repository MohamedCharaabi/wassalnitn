import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wassalni/modelView/providers/user_provider.dart';
import 'package:wassalni/models/ChatMessage.dart';
import 'package:wassalni/models/message_model.dart';
import 'package:wassalni/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wassalni/utils/responsive.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.uid!;
    Responsive _responsive = Responsive(context);
    return Column(
      crossAxisAlignment: message.sender == currentUserId
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _responsive.getWidth(.7),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2),
            decoration: BoxDecoration(
              color: message.sender == currentUserId ? Colors.grey : mainColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              message.message,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Text(
          timeago.format(DateTime.parse(message.createdAt), locale: 'en_short'),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
