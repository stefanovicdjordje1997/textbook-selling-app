import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/constant/local_keys.dart';
import 'package:textbook_selling_app/core/services/auth_service.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/core/notifications/snack_bar.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState());

  void onTabSelected(int index) {
    if (index == 2) return;
    state = state.copyWith(index: index);
  }

  void logout(BuildContext context) async {
    showLoader(context);

    try {
      await AuthService.logoutUser();
      if (context.mounted) {
        hideLoader(context);
      }
    } catch (error) {
      if (context.mounted) {
        if (error is FirebaseAuthException) {
          showSnackBar(
              context: context,
              message: error.message ??
                  AppLocalizations.getString(LocalKeys.unknownErrorMessage),
              type: SnackBarType.error);
        } else {
          showSnackBar(
              context: context,
              message:
                  AppLocalizations.getString(LocalKeys.anErrorOccuredMessage),
              type: SnackBarType.error);
        }
      }
    }
  }
}

class HomeState {
  final int? index;

  HomeState({this.index});

  HomeState copyWith({
    final int? index,
  }) {
    return HomeState(
      index: index ?? this.index,
    );
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(),
);
