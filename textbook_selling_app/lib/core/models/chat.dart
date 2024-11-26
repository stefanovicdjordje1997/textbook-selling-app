import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:textbook_selling_app/core/models/message.dart';
import 'package:textbook_selling_app/core/models/user.dart';

class Chat {
  final String id; // ID četa
  final List<User>
      users; // Lista korisnika u četu (obično 2 korisnika za privatni čet)
  final List<Message> messages; // Lista poruka, poređanih hronološki
  final DateTime createdAt; // Datum kreiranja četa
  final String?
      lastMessage; // Tekst poslednje poruke za lakši prikaz u listama četa
  final DateTime? lastMessageTime; // Vreme poslednje poruke

  Chat({
    required this.id,
    required this.users,
    required this.messages,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  // Kreiranje instance iz Firestore dokumenta
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      users: (data['users'] as List)
          .map((user) => User.fromMap(user as Map<String, dynamic>))
          .toList(),
      messages: (data['messages'] as List)
          .map((msg) => Message.fromMap(msg as Map<String, dynamic>))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  // Konvertovanje instance u mapu za Firestore
  Map<String, dynamic> toMap() {
    return {
      'users': users.map((user) => user.toMap()).toList(),
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
