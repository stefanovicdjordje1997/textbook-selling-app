class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
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
      return '$fieldName cannot be empty';
    }

    // Regex pattern depending on whether numbers are allowed
    final nameRegex = allowNumbers
        ? RegExp(
            r'^[a-zA-Z0-9\s]+(\.[a-zA-Z0-9])?$') // Letters, numbers, and initials (with .)
        : RegExp(
            r'^[a-zA-Z\s]+(\.?[a-zA-Z\s]*)$'); // Only letters and initials (with .)

    if (!nameRegex.hasMatch(value.trim())) {
      return allowNumbers
          ? 'Enter valid text (letters, numbers, or initials)'
          : 'Enter a valid text (letters or initials)';
    }

    if (value.trim().length < 2) {
      return 'Too short';
    }

    return null;
  }

  // Phone number validator
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number cannot be empty';
    }
    final phoneRegex = RegExp(r'^[0-9]{4,14}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // Year validator
  static String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Year cannot be empty';
    }

    final year = int.tryParse(value.trim());
    if (year == null) {
      return 'Enter a valid number';
    }

    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return 'Enter a valid year between 1900 and $currentYear';
    }

    return null;
  }

  // Price validator
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price cannot be empty';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Enter a valid number';
    }

    if (price <= 0) {
      return 'Price must be greater than zero';
    }

    return null;
  }

  // Year of study validator
  static String? validateYearOfStudy(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Study year cannot be empty';
    }

    final year = int.tryParse(value.trim());

    if (year == null) {
      return 'Enter a valid number';
    }
    if (year < 1 || year > 6) {
      return 'Enter a valid study year between 1 and 6';
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
        return 'Please select a $fieldName';
      }
      return null;
    }
  }
}
