import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/models/user.dart';

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
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<List<TextBook>> getAllTextbooks() async {
    try {
      // Dohvati sve dokumente iz kolekcije 'textbooks'
      QuerySnapshot snapshot = await _firestore.collection('textbooks').get();
      List<TextBook> textbooks = [];

      // Iteriraj kroz svaki dokument
      for (var doc in snapshot.docs) {
        // Dobij informacije o korisniku koji je dodao knjigu
        String userId = doc['addedBy'];
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        User user = User(
          userDoc['name'],
          userDoc['surname'],
          userDoc['email'],
          userDoc['dateOfBirth'] != null
              ? DateTime.parse(userDoc['dateOfBirth'])
              : null,
          userDoc['phoneNumber'],
          userDoc['profilePhotoURL'],
        );

        // Kreiraj TextBook objekat
        TextBook textbook = TextBook(
          user: user,
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
          damaged: doc['damaged'],
          degreeLevel: doc['degreeLevel'],
          description: doc['description'],
          imageUrls: List<String>.from(doc['imageUrls']),
          institution: doc['institution'],
          institutionType: doc['institutionType'],
          major: doc['major'],
          name: doc['name'],
          price: (doc['price'] as num).toDouble(),
          subject: doc['subject'],
          university: doc['university'],
          used: doc['used'],
          yearOfPublication: doc['yearOfPublication'],
          yearOfStudy: doc['yearOfStudy'],
        );

        // Dodaj TextBook objekat u listu
        textbooks.add(textbook);
      }
      return textbooks;
    } on FirebaseException {
      rethrow;
    }
  }
}
