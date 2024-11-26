import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> userIds;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  Chat({
    required this.id,
    required this.userIds,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  // Kreiranje instance iz Firestore dokumenta
  static Future<Chat> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    return Chat(
      id: doc.id,
      userIds: List<String>.from(data['users']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': userIds,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
