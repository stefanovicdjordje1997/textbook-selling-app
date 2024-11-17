class User {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String? profilePhoto;
  final List<String> favorites;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.profilePhoto,
    this.favorites = const [],
  });
}
