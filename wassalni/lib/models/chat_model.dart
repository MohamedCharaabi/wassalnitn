class ChatModel {
  List<String> users_ids;
  String chat_id;
  List<Map<String, dynamic>>? messages;

  ChatModel({required this.users_ids, required this.chat_id, this.messages});

  factory ChatModel.fromMap(Map<String, dynamic> map, String chat_id) {
    return ChatModel(
      users_ids: map['users'] ?? [],
      chat_id: chat_id,
      messages: map['messages'],
    );
  }
}
