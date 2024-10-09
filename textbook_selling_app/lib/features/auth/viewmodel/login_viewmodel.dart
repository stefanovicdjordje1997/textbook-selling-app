import 'package:flutter/material.dart';
import 'package:textbook_selling_app/core/utils/validators.dart';

class LoginViewmodel {
  // Dodavanje GlobalKey za formu
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Polja za unos
  String? email;
  String? password;

  // Validacija email-a
  String? validateEmail(String? value) => Validators.validateEmail(value);

  // Validacija lozinke
  String? validatePassword(String? value) => Validators.validatePassword(value);

  // Čuvanje unosa email-a
  void onSavedEmail(String? value) => email = value;

  // Čuvanje unosa lozinke
  void onSavedPassword(String? value) => password = value;

  // Validacija forme
  bool validateForm() => formKey.currentState?.validate() ?? false;

  // Čuvanje unosa u formi
  void saveForm() {
    if (validateForm()) {
      formKey.currentState?.save();
    }
  }
}
