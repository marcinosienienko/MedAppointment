class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? avatarUrl;
  final String? street;
  final String? houseNumber;
  final String? apartmentNumber;
  final String? city;
  final String? pesel; // Zaszyfrowany PESEL

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.avatarUrl,
    this.street,
    this.houseNumber,
    this.apartmentNumber,
    this.city,
    this.pesel,
  });

  String get name => '$firstName $lastName';

  factory UserModel.fromMap(Map<String, dynamic> data, String userId) {
    return UserModel(
      id: userId,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      avatarUrl: data['avatarUrl'],
      street: data['street'],
      houseNumber: data['houseNumber'],
      apartmentNumber: data['apartmentNumber'],
      city: data['city'],
      pesel: data['pesel'], // Zaszyfrowany PESEL
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'avatarUrl': avatarUrl,
        'street': street,
        'houseNumber': houseNumber,
        'apartmentNumber': apartmentNumber,
        'city': city,
        'pesel': pesel, // Zaszyfrowany PESEL
      };
}
