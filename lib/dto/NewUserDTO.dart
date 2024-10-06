class NewUserDTO {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final String number;
  final bool verified;

  NewUserDTO(
      {required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.number,
      required this.verified});

  factory NewUserDTO.fromJson(Map<String, dynamic> json) {
    return NewUserDTO(
        username: json['username'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        number: json['number'],
        verified: json['verified']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'number': number,
      'verified': verified,
    };
  }
}
