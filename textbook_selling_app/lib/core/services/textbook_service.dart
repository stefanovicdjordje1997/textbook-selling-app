import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/models/textbook_response.dart';
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

  static Future<void> updateTextbook({
    required String textbookId,
    String? name,
    String? subject,
    String? description,
    int? yearOfStudy,
    int? yearOfPublication,
    String? institutionType,
    String? university,
    String? institution,
    String? degreeLevel,
    String? major,
    bool? used,
    bool? damaged,
    double? price,
    List<XFile>? images,
  }) async {
    try {
      // Check if the user is authenticated
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      // Reference to the textbook document
      DocumentReference textbookRef =
          _firestore.collection('textbooks').doc(textbookId);

      // Check if the document exists
      DocumentSnapshot textbookDoc = await textbookRef.get();
      if (!textbookDoc.exists) {
        throw FirebaseException(
          plugin: 'FirebaseFirestore',
          message: 'Textbook does not exist.',
        );
      }

      // Replace old images with new ones if provided
      List<String> newImageUrls = [];
      if (images != null && images.isNotEmpty) {
        // Delete existing images from Firebase Storage
        List<dynamic> existingImageUrls = textbookDoc['imageUrls'] ?? [];
        for (String imageUrl in existingImageUrls) {
          try {
            await _storage.refFromURL(imageUrl).delete();
          } catch (e) {
            // Log the error but continue with other images (image might not exist)
          }
        }

        // Upload new images to Firebase Storage
        List<File> fileImages =
            images.map((xFile) => File(xFile.path)).toList();
        for (File image in fileImages) {
          String imageName = image.path.split('/').last;
          final imageRef = _storage
              .ref()
              .child('textbook_images')
              .child(textbookId)
              .child(imageName);

          UploadTask uploadTask = imageRef.putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          String downloadURL = await snapshot.ref.getDownloadURL();
          newImageUrls.add(downloadURL);
          print('----------> IMAGE URL: ${downloadURL}');
        }
      }

      // Update textbook details in Firestore
      await textbookRef.update({
        if (name != null) 'name': name,
        if (subject != null) 'subject': subject,
        if (description != null) 'description': description,
        if (yearOfStudy != null) 'yearOfStudy': yearOfStudy,
        if (yearOfPublication != null) 'yearOfPublication': yearOfPublication,
        if (institutionType != null) 'institutionType': institutionType,
        if (university != null) 'university': university,
        if (institution != null) 'institution': institution,
        if (degreeLevel != null) 'degreeLevel': degreeLevel,
        if (major != null) 'major': major,
        if (used != null) 'used': used,
        if (damaged != null) 'damaged': damaged,
        if (price != null) 'price': price,
        if (images != null) 'imageUrls': newImageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<TextbooksResponse> getAllTextbooks({
    required int page,
    required int limit,
  }) async {
    try {
      // Prvo dohvati ukupan broj elemenata za proračunavanje broja strana
      AggregateQuerySnapshot countSnapshot =
          await _firestore.collection('textbooks').count().get();
      int totalItems = countSnapshot.count ?? 0;

      // Proračunaj ukupan broj strana
      int totalPages = (totalItems / limit).ceil();

      Query query = _firestore
          .collection('textbooks')
          .orderBy('createdAt', descending: true) // Order by creation date
          .limit(limit);

      // Apply startAfterDocument only if not on the first page
      if (page > 0) {
        // Get the last document of the previous page
        QuerySnapshot previousPageSnapshot =
            await query.limit(page * limit).get();
        if (previousPageSnapshot.docs.isNotEmpty) {
          DocumentSnapshot lastDocument = previousPageSnapshot.docs.last;
          query = query.startAfterDocument(lastDocument);
        }
      }

      QuerySnapshot snapshot = await query.get();

      List<Textbook> textbooks = [];

      for (var doc in snapshot.docs) {
        // Load the user as before
        String userId = doc['addedBy'];
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        List<String> favorites = [];
        if (userDoc['favorites'] != null) {
          favorites = userDoc['favorites'] is List
              ? List<String>.from(userDoc['favorites'])
              : [];
        }

        User user = User(
          id: userId,
          firstName: userDoc['firstName'],
          lastName: userDoc['lastName'],
          email: userDoc['email'],
          dateOfBirth: DateTime.parse(userDoc['dateOfBirth']),
          phoneNumber: userDoc['phoneNumber'],
          profilePhoto: userDoc['profilePhotoURL'],
          favorites: favorites,
        );

        Textbook textbook = Textbook(
          id: doc.id,
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

        textbooks.add(textbook);
      }

      return TextbooksResponse(
        textbooks: textbooks,
        totalItems: totalItems,
        totalPages: totalPages,
        currentPage: page,
      );
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<List<Textbook>> getFavoriteTextbooks() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      // Dohvati korisnika i njegove omiljene knjige
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      List<String> favoriteIds = [];
      if (userDoc['favorites'] != null) {
        favoriteIds = userDoc['favorites'] is List
            ? List<String>.from(userDoc['favorites'])
            : [];
      }

      if (favoriteIds.isEmpty) {
        return [];
      }

      // Dohvati knjige na osnovu omiljenih ID-ova
      QuerySnapshot snapshot = await _firestore
          .collection('textbooks')
          .orderBy('createdAt', descending: true)
          .where(FieldPath.documentId, whereIn: favoriteIds)
          .get();

      List<Textbook> favoriteTextbooks = [];
      for (var doc in snapshot.docs) {
        // Učitaj podatke o korisniku koji je dodao udžbenik
        String userId = doc['addedBy'];
        DocumentSnapshot textbookUserDoc =
            await _firestore.collection('users').doc(userId).get();

        List<String> favorites = [];
        if (textbookUserDoc['favorites'] != null) {
          favorites = textbookUserDoc['favorites'] is List
              ? List<String>.from(textbookUserDoc['favorites'])
              : [];
        }

        User textbookUser = User(
          id: userId,
          firstName: textbookUserDoc['firstName'],
          lastName: textbookUserDoc['lastName'],
          email: textbookUserDoc['email'],
          dateOfBirth: DateTime.parse(textbookUserDoc['dateOfBirth']),
          phoneNumber: textbookUserDoc['phoneNumber'],
          profilePhoto: textbookUserDoc['profilePhotoURL'],
          favorites: favorites,
        );

        // Dodaj knjigu sa korisničkim podacima
        favoriteTextbooks.add(Textbook(
          id: doc.id,
          user: textbookUser,
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
        ));
      }

      return favoriteTextbooks;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> toggleFavoriteStatus(String textbookId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      DocumentReference userRef = _firestore.collection('users').doc(user.uid);

      // Check if the book is already in favorites
      DocumentSnapshot userDoc = await userRef.get();
      List<String> favorites = [];
      if (userDoc['favorites'] != null) {
        favorites = userDoc['favorites'] is List
            ? List<String>.from(userDoc['favorites'])
            : [];
      }

      if (favorites.contains(textbookId)) {
        // Remove from favorites
        favorites.remove(textbookId);
      } else {
        // Add to favorites
        favorites.add(textbookId);
      }

      // Update the favorites in Firestore
      await userRef.update({'favorites': favorites});
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<bool> isFavorite(String textbookId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      List<String> favorites = [];
      if (userDoc['favorites'] != null) {
        favorites = userDoc['favorites'] is List
            ? List<String>.from(userDoc['favorites'])
            : [];
      }

      return favorites.contains(textbookId);
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<List<Textbook>> getMyTextbooks() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'User not authenticated.',
        );
      }

      // Dohvati korisnika i njegove dodane knjige
      QuerySnapshot snapshot = await _firestore
          .collection('textbooks')
          .where('addedBy', isEqualTo: user.uid)
          .get();

      List<Textbook> userTextbooks = [];
      for (var doc in snapshot.docs) {
        // Load the user who added the textbook
        String userId = doc['addedBy'];
        DocumentSnapshot textbookUserDoc =
            await _firestore.collection('users').doc(userId).get();

        List<String> favorites = [];
        if (textbookUserDoc['favorites'] != null) {
          favorites = textbookUserDoc['favorites'] is List
              ? List<String>.from(textbookUserDoc['favorites'])
              : [];
        }

        User textbookUser = User(
          id: userId,
          firstName: textbookUserDoc['firstName'],
          lastName: textbookUserDoc['lastName'],
          email: textbookUserDoc['email'],
          dateOfBirth: DateTime.parse(textbookUserDoc['dateOfBirth']),
          phoneNumber: textbookUserDoc['phoneNumber'],
          profilePhoto: textbookUserDoc['profilePhotoURL'],
          favorites: favorites,
        );

        // Add textbook with user data
        userTextbooks.add(Textbook(
          id: doc.id,
          user: textbookUser,
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
        ));
      }

      return userTextbooks;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> removeMyTextbook(String textbookId) async {
    // Referenca na folder textbookId
    Reference folderRef = FirebaseStorage.instance
        .ref()
        .child('textbook_images')
        .child(textbookId);

    // Preuzmi sve fajlove unutar foldera
    ListResult result = await folderRef.listAll();

    // Obrisi sve fajlove
    for (var item in result.items) {
      try {
        // Obrisi fajl
        await item.delete();
        print('Fajl ${item.name} obrisan');
      } catch (e) {
        print('Greška pri brisanju fajla ${item.name}: $e');
      }
    }

    // Na kraju, obriši fajl koji predstavlja `textbookId` (ako postoji)
    try {
      await folderRef.delete();
      print('Folder textbook_images/$textbookId je obrisan');
    } catch (e) {
      print('Greška pri brisanju foldera textbook_images/$textbookId: $e');
    }

    // Obrisi dokument iz Firestore-a
    try {
      await FirebaseFirestore.instance
          .collection('textbooks') // Naziv kolekcije u Firestore-u
          .doc(textbookId) // ID dokumenta za brisanje
          .delete();
      print('Dokument sa ID-jem $textbookId je obrisan iz Firestore-a');
    } catch (e) {
      print('Greška pri brisanju dokumenta $textbookId iz Firestore-a: $e');
    }
  }
}
