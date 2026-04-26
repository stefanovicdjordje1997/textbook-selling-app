import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';

class MyTextbooksViewModel extends StateNotifier<MyTextbooksState> {
  MyTextbooksViewModel() : super(MyTextbooksState());

  Future<void> fetchUserTextbooks() async {
    state = state.copyWith(isLoading: true);
    try {
      final textbooks = await TextbookService.getMyTextbooks();
      state = state.copyWith(userTextbooks: textbooks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error fetching user textbooks: $e');
    }
  }

  Future<void> removeUserTextbook(Textbook textbook) async {
    try {
      await TextbookService.removeMyTextbook(textbook.id);
      final textbooks = state.userTextbooks;
      textbooks.remove(textbook);
      state = state.copyWith(userTextbooks: textbooks);
    } catch (e) {
      print('Error removing user textbook: $e');
    }
  }
}

class MyTextbooksState {
  final List<Textbook> userTextbooks;
  final bool isLoading;

  MyTextbooksState({
    this.userTextbooks = const [],
    this.isLoading = false,
  });

  MyTextbooksState copyWith({
    List<Textbook>? userTextbooks,
    bool? isLoading,
  }) {
    return MyTextbooksState(
      userTextbooks: userTextbooks ?? this.userTextbooks,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final userTextbooksProvider =
    StateNotifierProvider<MyTextbooksViewModel, MyTextbooksState>(
  (ref) => MyTextbooksViewModel(),
);
