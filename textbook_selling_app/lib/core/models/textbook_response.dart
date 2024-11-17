import 'package:textbook_selling_app/core/models/textbook.dart';

class TextbooksResponse {
  final List<Textbook> textbooks;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  TextbooksResponse({
    required this.textbooks,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });
}
