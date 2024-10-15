import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textbook_selling_app/core/utils/auth_service.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/core/utils/snack_bar.dart';
import 'package:textbook_selling_app/core/utils/validators.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Validators
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validatePassword(String? value) => Validators.validatePassword(value);

  // On save methods
  void onSavedEmail(String? value) => state = state.copyWith(email: value);
  void onSavedPassword(String? value) =>
      state = state.copyWith(password: value);

  // Form validation
  bool validateForm() => formKey.currentState?.validate() ?? false;

  void saveForm(BuildContext context) async {
    if (validateForm()) {
      formKey.currentState?.save();

      showLoader(context);
      try {
        await AuthService.loginUser(
            email: state.email, password: state.password);
        // Go to home page
      } catch (error) {
        if (context.mounted) {
          hideLoader(context);
          if (error is FirebaseAuthException) {
            showSnackBar(
                context: context,
                message: error.message ?? 'Unknown error.',
                type: SnackBarType.error);
          } else {
            showSnackBar(
                context: context,
                message: 'An error occured!',
                type: SnackBarType.error);
          }
        }
      }
    }
  }
}

// Login state
class LoginState {
  final String? email;
  final String? password;

  LoginState({
    this.email,
    this.password,
  });

  LoginState copyWith({
    String? email,
    String? password,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(),
);
