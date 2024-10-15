import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod/riverpod.dart';
import 'package:textbook_selling_app/core/utils/loader_functions.dart';
import 'package:textbook_selling_app/core/utils/validators.dart';
import 'package:textbook_selling_app/core/utils/snack_bar.dart';
import 'package:textbook_selling_app/core/utils/auth_service.dart';

// StateNotifier
class RegisterViewModel extends StateNotifier<RegisterState> {
  RegisterViewModel() : super(RegisterState());

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _defaultItem = {};

  // Get data with countries and dial codes
  Future<void> loadCountries() async {
    String data =
        await rootBundle.loadString('lib/core/assets/country_codes.json');
    List<dynamic> items = jsonDecode(data);

    final serbia = items.firstWhere(
      (country) => country['name'] == 'Serbia',
      orElse: () => {},
    );
    // Setting the default dial code value
    if (serbia != null && serbia.isNotEmpty) {
      _defaultItem = serbia;
    }

    state = state.copyWith(countries: items, defaultItem: _defaultItem);
  }

  // Image picker methods
  Future<void> pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      state = state.copyWith(pickedImageFile: File(pickedImage.path));
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      state = state.copyWith(pickedImageFile: File(pickedImage.path));
    }
  }

  void removeImage() {
    state = state.copyWith(pickedImageFile: File(''));
  }

  // Validators
  String? validateEmail(String? value) => Validators.validateEmail(value);
  String? validateText({String? value, String? fieldName}) =>
      Validators.validateText(value: value, fieldName: fieldName);
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
    state = state.copyWith(email: value);
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

  // Form validation
  bool validateForm() => formKey.currentState?.validate() ?? false;

  // Save form when register button is clicked
  void saveForm(BuildContext context) async {
    if (validateForm()) {
      formKey.currentState?.save();

      final fullPhoneNumber = state.dialCode! + state.phoneNumber!;

      showLoader(context);
      // Create new user in database (register)
      try {
        await AuthService.registerUser(
            name: state.name,
            surname: state.surname,
            dateOfBirth: state.dateOfBirth,
            phoneNumber: fullPhoneNumber,
            email: state.email,
            password: state.password,
            profilePhoto: state.pickedImageFile);
        if (context.mounted) {
          hideLoader(context);
        }
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

// Define RegisterState
class RegisterState {
  final String? name;
  final String? surname;
  final String? email;
  final String? password;
  final DateTime? dateOfBirth;
  final String? dialCode;
  final String? phoneNumber;
  final List<dynamic>? countries;
  final dynamic defaultItem;
  final File? pickedImageFile;

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
    this.pickedImageFile,
  });

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
    File? pickedImageFile,
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
      pickedImageFile: pickedImageFile ?? this.pickedImageFile,
    );
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>(
  (ref) => RegisterViewModel(),
);
