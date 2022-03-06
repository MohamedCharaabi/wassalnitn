import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding,
      ),
      decoration: BoxDecoration(
        color: mainColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(children: [
          Icon(Icons.mic, color: white),
          SizedBox(
            width: kDefaultPadding,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
              decoration: BoxDecoration(
                color: white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    color: white.withOpacity(0.64),
                  ),
                  SizedBox(width: kDefaultPadding / 4),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color: white.withOpacity(0.64),
                  ),
                  SizedBox(width: kDefaultPadding / 4),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: white.withOpacity(0.64),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
