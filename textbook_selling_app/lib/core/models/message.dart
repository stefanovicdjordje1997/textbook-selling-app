import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id; // ID poruke
  final String senderId; // ID korisnika koji je poslao poruku
  final String text; // Tekst poruke
  final DateTime timestamp; // Datum i vreme slanja

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  // Kreiranje instance iz Firestore dokumenta
  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      id: data['id'],
      senderId: data['senderId'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Konvertovanje instance u mapu za Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
