import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';

class AllTextbooksViewModel extends StateNotifier<AllTextbooksState> {
  AllTextbooksViewModel() : super(AllTextbooksState());

  Future<void> fetchTextbooks({
    required BuildContext context,
    int page = 0,
    int limit = 10,
  }) async {
    if (state.isLoading) return; // Izbegava ponovno učitavanje

    // Prikaži loader i ažuriraj stanje
    state = state.copyWith(isLoading: true);

    try {
      // Dohvati udžbenike iz servisa
      final response =
          await TextbookService.getAllTextbooks(page: page, limit: limit);

      if (response.totalPages == page) return;

      // Dodaj udžbenike u stanje
      state = state.copyWith(
        textbooks: [...?state.textbooks, ...response.textbooks],
        totalItems: response.totalItems,
        totalPages: response.totalPages,
        currentPage: page,
        isLoading: false,
      );
    } catch (error) {
      if (context.mounted) {
        showSnackBar(
          context: context,
          message: error is FirebaseException
              ? error.message ??
                  AppLocalizations.getString(LocalKeys.unknownErrorMessage)
              : AppLocalizations.getString(LocalKeys.anErrorOccuredMessage),
          type: SnackBarType.error,
        );
      }
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshTextbooks(BuildContext context, int limit) async {
    state = AllTextbooksState(); // Resetuje stanje
    await fetchTextbooks(context: context, limit: limit); // Ponovno učitavanje
  }
}

class AllTextbooksState {
  final List<Textbook>? textbooks;
  final int currentPage;
  final int totalItems;
  final int totalPages;
  final bool isLoading;

  AllTextbooksState({
    this.textbooks,
    this.currentPage = 0,
    this.totalItems = 0,
    this.totalPages = 0,
    this.isLoading = false,
  });

  AllTextbooksState copyWith({
    List<Textbook>? textbooks,
    int? currentPage,
    int? totalItems,
    int? totalPages,
    bool? isLoading,
  }) {
    return AllTextbooksState(
      textbooks: textbooks ?? this.textbooks,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final allTextbooksProvider =
    StateNotifierProvider<AllTextbooksViewModel, AllTextbooksState>(
  (ref) => AllTextbooksViewModel(),
);
