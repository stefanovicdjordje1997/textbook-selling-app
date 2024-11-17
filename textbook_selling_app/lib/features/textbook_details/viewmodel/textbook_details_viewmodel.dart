import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';

class TextbookDetailsViewModel extends StateNotifier<TextbookDetailsState> {
  TextbookDetailsViewModel() : super(TextbookDetailsState());

  Future<void> loadFavoriteStatus(Textbook textbook) async {
    bool favorite = await TextbookService.isFavorite(textbook.id);
    state = state.copyWith(isFavorite: favorite);
  }

  Future<void> toggleFavorite(Textbook textbook) async {
    await TextbookService.toggleFavoriteStatus(textbook.id);
    state = state.copyWith(isFavorite: !state.isFavorite);
  }
}

class TextbookDetailsState {
  final bool isFavorite;

  TextbookDetailsState({
    this.isFavorite = false,
  });

  TextbookDetailsState copyWith({
    bool? isFavorite,
  }) {
    return TextbookDetailsState(
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

final textbookDetailsProvider =
    StateNotifierProvider<TextbookDetailsViewModel, TextbookDetailsState>(
  (ref) => TextbookDetailsViewModel(),
);
