// lib/models/user.dart

class User {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String username;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'username': username,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      username: json['username'],
      password: json['password'],
    );
  }
}
