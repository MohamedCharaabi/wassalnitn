import 'package:wassalni/models/message_model.dart';

class RoomModel {
  String createAt;
  List<dynamic> users;
  List<MessageModel> messages;

  RoomModel(
      {required this.createAt, required this.users, required this.messages});

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      createAt: map['createdAt'] ?? '',
      users: map['users'],
      messages: map['messages']
          .map<MessageModel>((value) => MessageModel.fromMap(value))
          .toList(),
    );
  }
}
