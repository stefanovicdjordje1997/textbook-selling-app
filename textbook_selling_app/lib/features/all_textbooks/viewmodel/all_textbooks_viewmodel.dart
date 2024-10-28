import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/models/textbook.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';
import 'package:textbook_selling_app/core/services/textbook_service.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';

class AllTextbooksViewModel extends StateNotifier<AllTextbooksState> {
  AllTextbooksViewModel() : super(AllTextbooksState());

  Future<void> getAllTextbooks(BuildContext context) async {
    List<TextBook> textbooks = [];

    showLoader(context);
    try {
      textbooks = await TextbookService.getAllTextbooks();
      if (context.mounted) {
        hideLoader(context);
      }
    } catch (error) {
      if (context.mounted) {
        hideLoader(context);
        if (error is FirebaseException) {
          showSnackBar(
            context: context,
            message: error.message ??
                AppLocalizations.getString(LocalKeys.unknownErrorMessage),
            type: SnackBarType.error,
          );
        } else {
          showSnackBar(
            context: context,
            message:
                AppLocalizations.getString(LocalKeys.anErrorOccuredMessage),
            type: SnackBarType.error,
          );
        }
      }
    }
    state = state.copyWith(textbooks: textbooks);
  }
}

class AllTextbooksState {
  final List<TextBook>? textbooks;

  AllTextbooksState({this.textbooks});

  AllTextbooksState copyWith({final List<TextBook>? textbooks}) {
    return AllTextbooksState(
      textbooks: textbooks ?? this.textbooks,
    );
  }
}

final allTextbooksProvider =
    StateNotifierProvider<AllTextbooksViewModel, AllTextbooksState>(
  (ref) => AllTextbooksViewModel(),
);
