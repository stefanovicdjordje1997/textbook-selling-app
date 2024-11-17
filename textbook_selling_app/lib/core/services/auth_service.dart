import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class AuthService {
  static Future<void> registerUser({
    required String? firstName,
    required String? lastName,
    required DateTime? dateOfBirth,
    required String? phoneNumber,
    required String? email,
    required String? password,
    File? profilePhoto,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );
      User? user = userCredential.user;

      if (user != null) {
        String? photoURL;

        if (profilePhoto != null && profilePhoto.path != '') {
          final photoRef = _storage
              .ref()
              .child('user_profile_photos')
              .child('${user.uid}.jpg');

          UploadTask uploadTask = photoRef.putFile(profilePhoto);
          TaskSnapshot snapshot = await uploadTask;
          photoURL = await snapshot.ref.getDownloadURL();
        }

        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'dateOfBirth':
              dateOfBirth != null ? dateOfBirth.toIso8601String() : '',
          'phoneNumber': phoneNumber,
          'email': email,
          'profilePhotoURL': photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  static Future<void> loginUser({
    required String? email,
    required String? password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email ?? '',
        password: password ?? '',
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  static Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
