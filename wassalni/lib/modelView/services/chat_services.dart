import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wassalni/models/chat_model.dart';

class ChatService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserChats(String userId) {
    final data = _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots();

    return data;
    // return data.map((event) => ChatModel.fromMap(event, event.id));
  }

  Future<DocumentReference> sendMessage(
      String userId, String message, String chatId) async {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'from': userId,
      'text': message,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future<void> createChat(String userId, String interlocutorId) async {
    List<String> users = [];
    users.add(userId);
    users.add(interlocutorId);
    users.sort();
    String chatId = users[0] + users[1];
    await _firestore.collection('chats').doc(chatId).set({
      'users': users,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}
