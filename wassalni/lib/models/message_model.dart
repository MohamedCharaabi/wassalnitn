class MessageModel {
  String createdAt;
  String message;
  String sender; // true if current user is the sender

  MessageModel({
    required this.createdAt,
    required this.message,
    required this.sender,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      createdAt: map['createdAt'] ?? '',
      message: map['message'] ?? '',
      sender: map['senderId'] ?? '',
    );
  }
}
