import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';

class FavoriteTextbooksViewModel extends StateNotifier<FavoriteTextbooksState> {
  FavoriteTextbooksViewModel() : super(FavoriteTextbooksState());

  Future<void> fetchFavoriteTextbooks() async {
    state = state.copyWith(isLoading: true);
    try {
      final textbooks = await TextbookService.getFavoriteTextbooks();
      state = state.copyWith(favoriteTextbooks: textbooks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error fetching favorite textbooks: $e');
    }
  }

  Future<void> removeFavorite(Textbook textbook) async {
    try {
      await TextbookService.toggleFavoriteStatus(textbook.id);
      final textbooks = state.favoriteTextbooks;
      textbooks.remove(textbook);
      state = state.copyWith(favoriteTextbooks: textbooks);
    } catch (e) {
      print('Error removing favorite textbook: $e');
    }
  }
}

class FavoriteTextbooksState {
  final List<Textbook> favoriteTextbooks;
  final bool isLoading;

  FavoriteTextbooksState({
    this.favoriteTextbooks = const [],
    this.isLoading = false,
  });

  FavoriteTextbooksState copyWith({
    List<Textbook>? favoriteTextbooks,
    bool? isLoading,
  }) {
    return FavoriteTextbooksState(
      favoriteTextbooks: favoriteTextbooks ?? this.favoriteTextbooks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final favoriteTextbooksProvider =
    StateNotifierProvider<FavoriteTextbooksViewModel, FavoriteTextbooksState>(
  (ref) => FavoriteTextbooksViewModel(),
);
