import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final _storage = FirebaseStorage.instance;

class TextbookService {
  static Future<void> addTextbook({
    required String? name,
    required String? subject,
    required String? description,
    required int? yearOfStudy,
    required int? yearOfPublication,
    required String? institutionType,
    required String? university,
    required String? institution,
    required String? degreeLevel,
    required String? major,
    required bool? used,
    required bool? damaged,
    required double? price,
    List<XFile>? images,
  }) async {
    try {
      // Get the current user ID
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      // Create a new textbook document with a unique ID
      DocumentReference textbookRef = _firestore.collection('textbooks').doc();
      String textbookId = textbookRef.id;

      List<File>? fileImages =
          images?.map((xFile) => File(xFile.path)).toList();

      // Save images to Firebase Storage in a unique folder for this textbook
      List<String> imageUrls = [];
      if (images != null && images.isNotEmpty) {
        for (File image in fileImages ?? []) {
          String imageName = image.path.split('/').last;
          final imageRef = _storage
              .ref()
              .child('textbook_images')
              .child(textbookId)
              .child(imageName);

          UploadTask uploadTask = imageRef.putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          String downloadURL = await snapshot.ref.getDownloadURL();
          imageUrls.add(downloadURL);
        }
      }

      // Save textbook data to Firestore
      await textbookRef.set({
        'name': name ?? '',
        'subject': subject ?? '',
        'description': description ?? '',
        'yearOfStudy': yearOfStudy ?? 0,
        'yearOfPublication': yearOfPublication ?? 0,
        'institutionType': institutionType ?? '',
        'university': university ?? '',
        'institution': institution ?? '',
        'degreeLevel': degreeLevel ?? '',
        'major': major ?? '',
        'used': used ?? false,
        'damaged': damaged ?? false,
        'price': price ?? 0,
        'imageUrls': imageUrls,
        'addedBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
