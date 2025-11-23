class User {
  final String fullName, email, phoneNumber, address, username, password;

  User(
      {required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.address,
      required this.username,
      required this.password});

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'username': username,
        'password': password
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json['fullName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        username: json['username'],
        password: json['password'],
      );
}
