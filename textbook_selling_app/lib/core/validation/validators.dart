import 'package:textbook_selling_app/core/constants/local_keys.dart';
import 'package:textbook_selling_app/core/constants/regex_patterns.dart';
import 'package:textbook_selling_app/core/localization/app_localizations.dart';

class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyEmail);
    }
    final emailRegex = RegExp(RegexPatterns.email);
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidEmail);
    }
    return null;
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyPassword);
    }
    if (value.length < 6) {
      return AppLocalizations.getString(LocalKeys.validatorShortPassword);
    }
    return null;
  }

  // Text validator
  static String? validateText({
    required String? value,
    String? fieldName = 'This field',
    bool allowNumbers = false, // Parameter to allow numbers
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${AppLocalizations.getString(LocalKeys.validatorEmptyText)}';
    }

    // Regex pattern depending on whether numbers are allowed
    final nameRegex = allowNumbers
        ? RegExp(RegexPatterns
            .nameAllowNumbers) // Letters, numbers, and initials (with .)
        : RegExp(RegexPatterns
            .nameNotAllowNumbers); // Only letters and initials (with .)

    if (!nameRegex.hasMatch(value.trim())) {
      return allowNumbers
          ? AppLocalizations.getString(
              LocalKeys.validatorInvalidTextAllowNumbers)
          : AppLocalizations.getString(
              LocalKeys.validatorInvalidTextNotAllowNumbers);
    }

    if (value.trim().length < 2) {
      return AppLocalizations.getString(LocalKeys.validatorShortText);
    }

    return null;
  }

  // Phone number validator
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyPhoneNumber);
    }
    final phoneRegex = RegExp(RegexPatterns.phoneNumber);
    if (!phoneRegex.hasMatch(value.trim())) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidPhoneNumber);
    }
    return null;
  }

  // Year validator
  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyYear);
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidNumber);
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return "${AppLocalizations.getString(LocalKeys.validatorInvalidYear)} $currentYear";
    }

    return null;
  }

  // Price validator
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyPrice);
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidPrice);
    }

    if (price <= 0) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidPrice);
    }

    return null;
  }

  // Year of study validator
  static String? validateYearOfStudy(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.getString(LocalKeys.validatorEmptyYearOfStudy);
    }

    final year = int.tryParse(value.trim());

    if (year == null) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidNumber);
    }
    if (year < 1 || year > 6) {
      return AppLocalizations.getString(LocalKeys.validatorInvalidYearOfStudy);
    }

    return null;
  }

  // Dropdown menu validator
  static String? validateDropdownField(
      String? value, List<String>? options, String fieldName) {
    {
      if (options == null || options.isEmpty) {
        return null;
      }
      if (value == null || value.isEmpty) {
        return '${AppLocalizations.getString(LocalKeys.validatorEmptyDropdown)} $fieldName';
      }
      return null;
    }
  }
}
