class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String? profilePhoto;
  final List<String> favorites;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.profilePhoto,
    this.favorites = const [],
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      dateOfBirth: DateTime.parse(data['dateOfBirth']),
      phoneNumber: data['phoneNumber'],
      profilePhoto: data['profilePhotoURL'],
      favorites: List<String>.from(data['favorites'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'profilePhoto': profilePhoto,
      'favorites': favorites,
    };
  }
}
