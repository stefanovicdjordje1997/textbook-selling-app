import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textbook_selling_app/core/models/chat.dart';
import 'package:textbook_selling_app/core/models/message.dart';
import 'package:textbook_selling_app/core/services/user_service.dart';

final _firestore = FirebaseFirestore.instance;

class ChatService {
  // Slanje poruke
  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      // Kreiranje nove poruke
      final newMessage = Message(
        id: _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc()
            .id,
        senderId: senderId,
        text: text,
        timestamp: DateTime.now(),
      );

      // Ažuriranje kolekcije poruka
      final chatRef = _firestore.collection('chats').doc(chatId);
      final messagesRef = chatRef.collection('messages');

      await messagesRef.doc(newMessage.id).set(newMessage.toMap());

      // Ažuriranje metapodataka četa
      await chatRef.update({
        'lastMessage': newMessage.text,
        'lastMessageTime': newMessage.timestamp,
      });
    } catch (e) {
      print("Error sending message: $e");
      throw Exception("Failed to send message");
    }
  }

  static Stream<List<Message>> streamMessages({
    required String userId1,
    required String userId2,
  }) {
    try {
      final chatId = generateChatId(userId1, userId2);

      // Referenca na kolekciju poruka
      final messagesRef =
          _firestore.collection('chats').doc(chatId).collection('messages');

      // Vraćanje stream-a koji prati promene u porukama
      return messagesRef.orderBy('timestamp').snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => Message.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      print("Error streaming messages: $e");
      throw Exception("Failed to stream messages");
    }
  }

  static String generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  static Future<void> createChatIfNotExists({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final chatRef =
          _firestore.collection('chats').doc(generateChatId(userId1, userId2));

      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'users': [userId1, userId2],
          'lastMessage': null,
          'lastMessageTime': null,
          'createdAt': DateTime.now(),
        });
      }
    } catch (e) {
      print("Error creating chat: $e");
      throw Exception("Failed to create chat");
    }
  }

  static Stream<List<Chat>> streamUserChats() {
    try {
      final userId = UserService.getUserId();

      return _firestore
          .collection('chats')
          .where('users', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((querySnapshot) async {
        final chats = await Future.wait(querySnapshot.docs
            .map((doc) async => await Chat.fromFirestore(doc)));
        return chats.where((chat) => chat.lastMessage != null).toList();
      }).asyncMap((futureList) =>
              futureList); // Pretvara Future<List> u Stream<List>
    } catch (e) {
      print("Error streaming user chats: $e");
      throw Exception("Failed to stream user chats");
    }
  }
}
