import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wassalni/models/chat_model.dart';
import 'package:wassalni/models/message_model.dart';
import 'package:wassalni/models/room_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RoomModel>> getUserChatsRooms(String userId) {
    final data = _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        // .orderBy('created_at', descending: true)
        .limit(5)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return RoomModel.fromMap(e.data());
      }).toList();
    });

    return data;
    // return data.map((event) => ChatModel.fromMap(event, event.id));
  }

  Future<String> getDocIdFromUers(
      {required String userId, required String receiverId}) async {
    List<String> users = [userId, receiverId];
    users.sort();

    final docId = await _firestore
        .collection('chats')
        .where('users', isEqualTo: users)
        .get()
        .then((value) => value.docs.first.id);

    return docId;
  }

  Future sendMessage({
    required String receiverId,
    required String userId,
    required String message,
  }) async {
    final chatId =
        await getDocIdFromUers(userId: userId, receiverId: receiverId);

// send message to firebase
    return _firestore.collection('chats').doc(chatId).update(
      {
        'createdAt': DateTime.now().toIso8601String(),
        'messages': FieldValue.arrayUnion([
          {
            'senderId': userId,
            'message': message,
            'createdAt': DateTime.now().toIso8601String(),
          }
        ]),
      },
    );
  }

  Future<void> createChat(String userId, String interlocutorId) async {
    List<String> users = [userId, interlocutorId];
    // users.add();
    // users.add(interlocutorId);
    users.sort();
    String chatId = users[0] + users[1];
    await _firestore.collection('chats').add({
      'messages': [],
      'users': users,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

// get chat with receiver id and current user
  Stream<RoomModel?>? getRoom(String receiverId, String currentUserId) {
    try {
      List<String> users = [];
      users.add(currentUserId);
      users.add(receiverId);
      users.sort();

      final Stream<RoomModel?>? result = _firestore
          .collection('chats')
          .where('users', isEqualTo: users)
          .snapshots()
          .map((event) {
        log('${event.docs.length}');
        if (event.docs.isNotEmpty) {
          return RoomModel.fromMap(event.docs.first.data());
        }

        createChat(currentUserId, receiverId)
            .then((value) => getRoom(receiverId, currentUserId));

        // return null;
      });

      log('result: ${result != null}');

      // if (await result.isEmpty) {
      //   await createChat(currentUserId, receiverId);
      //   return await getRoom(receiverId, currentUserId);
      // }
      // final data = await result.first.then((value) {
      //   return value.docs.first.data();
      // });

      // log('data: $data');
      // return RoomModel.fromMap(data);

      return result;
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future getUsersRoom(String receiverId, String currentUserId) async {
    try {
      final roomId;
      roomId = _firestore
          .collection('chats')
          .where('users', arrayContains: [receiverId, currentUserId]).get();
    } catch (e) {
      log("Error $e");
    }
  }

  Stream getRoomMessages(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
