import 'package:textbook_selling_app/core/models/user.dart';

class TextBook {
  final User user;
  final DateTime createdAt;
  final bool damaged;
  final String degreeLevel;
  final String description;
  final List<String> imageUrls;
  final String institution;
  final String institutionType;
  final String major;
  final String name;
  final double price;
  final String subject;
  final String university;
  final bool used;
  final int yearOfPublication;
  final int yearOfStudy;

  TextBook({
    required this.user,
    required this.createdAt,
    required this.damaged,
    required this.degreeLevel,
    required this.description,
    required this.imageUrls,
    required this.institution,
    required this.institutionType,
    required this.major,
    required this.name,
    required this.price,
    required this.subject,
    required this.university,
    required this.used,
    required this.yearOfPublication,
    required this.yearOfStudy,
  });
}
