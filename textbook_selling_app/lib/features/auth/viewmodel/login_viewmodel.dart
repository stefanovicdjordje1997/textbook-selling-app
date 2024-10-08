import 'package:flutter/material.dart';

class LoginViewmodel {
  // Dodavanje GlobalKey za formu
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Polja za unos
  String? email;
  String? password;

  // Validacija email-a
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Validacija lozinke
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Čuvanje unosa email-a
  void onSavedEmail(String? value) {
    email = value;
  }

  // Čuvanje unosa lozinke
  void onSavedPassword(String? value) {
    password = value;
  }

  // Validacija forme
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Čuvanje unosa u formi
  void saveForm() {
    formKey.currentState?.save();
  }
}
