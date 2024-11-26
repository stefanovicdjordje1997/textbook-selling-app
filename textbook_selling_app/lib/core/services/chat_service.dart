import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textbook_selling_app/core/models/message.dart';

class ChatService {
  // Slanje poruke
  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Kreiranje nove poruke
      final newMessage = Message(
        id: firestore
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
      final chatRef = firestore.collection('chats').doc(chatId);
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
      final firestore = FirebaseFirestore.instance;
      final chatId = generateChatId(userId1, userId2);

      // Referenca na kolekciju poruka
      final messagesRef =
          firestore.collection('chats').doc(chatId).collection('messages');

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

  // Dohvatanje poruka
  static Future<List<Message>> fetchMessages({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Generisanje ID četa
      final chatId = generateChatId(userId1, userId2);

      // Reference na čet dokument i kolekciju poruka
      final chatRef = firestore.collection('chats').doc(chatId);
      final messagesRef = chatRef.collection('messages');

      // Provera da li čet postoji
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        // Kreiraj čet ako ne postoji
        await _createChat(chatId: chatId, userId1: userId1, userId2: userId2);
        return []; // Vraća praznu listu jer još nema poruka
      }

      // Dohvatanje poruka, sortirano po vremenu slanja
      final querySnapshot = await messagesRef.orderBy('timestamp').get();
      return querySnapshot.docs
          .map((doc) => Message.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching messages: $e");
      throw Exception("Failed to fetch messages");
    }
  }

  // Privatna pomoćna funkcija za generisanje ID četa
  static String generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  // Privatna funkcija za kreiranje četa
  static Future<void> _createChat({
    required String chatId,
    required String userId1,
    required String userId2,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Kreiranje novog četa
      await firestore.collection('chats').doc(chatId).set({
        'users': [userId1, userId2],
        'lastMessage': null,
        'lastMessageTime': null,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print("Error creating chat: $e");
      throw Exception("Failed to create chat");
    }
  }
}
