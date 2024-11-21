import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:textbook_selling_app/core/models/user.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class UserService {
  static Future<User?> getUserData() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) {
        return null;
      }

      final data = userDoc.data()!;
      return User(
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        dateOfBirth: DateTime.parse(data['dateOfBirth']),
        phoneNumber: data['phoneNumber'] ?? '',
        profilePhoto: data['profilePhotoURL'],
        favorites: List<String>.from(data['favorites'] ?? []),
      );
    } catch (e) {
      rethrow;
    }
  }
}
