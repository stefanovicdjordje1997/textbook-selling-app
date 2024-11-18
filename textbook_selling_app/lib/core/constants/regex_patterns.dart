class RegexPatterns {
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneNumber = r'^[0-9]{4,14}$';
  static const String nameAllowNumbers = r'^[a-zA-Z0-9\s]+(\.[a-zA-Z0-9])?$';
  static const String nameNotAllowNumbers = r'^[a-zA-Z\s]+(\.?[a-zA-Z\s]*)$';
}
