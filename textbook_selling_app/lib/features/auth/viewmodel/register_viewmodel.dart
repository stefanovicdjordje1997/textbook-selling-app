import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:textbook_selling_app/core/utils/validators.dart';

// StateNotifier za upravljanje stanjem
class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel() : super(RegisterState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<dynamic> _countries = [];
  var _defaultItem = {};

  // Učitavanje podataka o zemljama
  Future<void> loadCountries() async {
    String data =
        await rootBundle.loadString('lib/core/assets/country_codes.json');
    List<dynamic> items = jsonDecode(data);

    final serbia = items.firstWhere(
      (country) => country['name'] == 'Serbia',
      orElse: () => {},
    );
    if (serbia != null && serbia.isNotEmpty) {
      _defaultItem = serbia;
    }

    // Ažuriranje stanja
    state = state.copyWith(countries: items, defaultItem: _defaultItem);
  }

  // Validators
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validateText(String? value) => Validators.validateText(value);
  String? validatePhoneNumber(String? value) =>
      Validators.validatePhoneNumber(value);

  String? validatePassword(String? value) {
    final message = Validators.validatePassword(value);
    if (message == null) {
      state = state.copyWith(password: value);
    }
    return message;
  }

  String? validateRepeatedPassword(String? value) {
    if (state.password != value) {
      return 'The repeated password doesn\'t match';
    }
    return null;
  }

  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  // On save methods
  void onSavedEmail(String? value) {
    state = state.copyWith(email: value); // Ažurira state.email
  }

  void onSavedPassword(String? value) {
    state = state.copyWith(password: value);
  }

  void onSavedName(String? value) {
    state = state.copyWith(name: value);
  }

  void onSavedSurname(String? value) {
    state = state.copyWith(surname: value);
  }

  void onSavedDateOfBirth(DateTime? value) {
    state = state.copyWith(dateOfBirth: value);
  }

  void onSavedDialCode(String? value) {
    state = state.copyWith(dialCode: value);
  }

  void onSavePhoneNumber(String? value) {
    state = state.copyWith(phoneNumber: value);
  }

  // Validacija forme
  bool validateForm() => formKey.currentState?.validate() ?? false;

  // Čuvanje unosa u formi
  void saveForm() {
    if (validateForm()) {
      formKey.currentState?.save();
      print(state.name);
      print(state.surname);
      print(state.email);
      print(state.password);
      print(state.dateOfBirth);
      print(state.dialCode! + state.phoneNumber!);
    }
  }
}

// Definisanje state-a za Register
class RegisterState {
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final DateTime? dateOfBirth;
  final String? dialCode;
  final String? phoneNumber;
  final List<dynamic>? countries; // Lista zemalja
  final dynamic defaultItem;

  RegisterState({
    this.name,
    this.surname,
    this.email,
    this.password,
    this.dateOfBirth,
    this.dialCode,
    this.phoneNumber,
    this.countries,
    this.defaultItem,
  });

  // copyWith metoda koja omogućava ažuriranje samo određenih polja
  RegisterState copyWith({
    String? name,
    String? surname,
    String? email,
    String? password,
    DateTime? dateOfBirth,
    String? dialCode,
    String? phoneNumber,
    List<dynamic>? countries,
    dynamic defaultItem,
  }) {
    return RegisterState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dialCode: dialCode ?? this.dialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countries: countries ?? this.countries,
      defaultItem: defaultItem ?? this.defaultItem,
    );
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>(
  (ref) => RegisterViewModel(),
);
