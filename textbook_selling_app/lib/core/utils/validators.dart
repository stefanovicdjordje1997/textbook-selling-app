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
  static String? validateText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s]+(\.[a-zA-Z])?$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid text';
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
}
