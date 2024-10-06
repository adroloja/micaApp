import 'dart:convert';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String numberPhone;
  final String email;
  final DateTime createdDate;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.numberPhone,
    required this.email,
    required this.createdDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      numberPhone: json['numberPhone'],
      email: json['email'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}

class LotteryWinnerDTO {
  final int id;
  final User user;
  final int number;
  final DateTime createdAt;

  LotteryWinnerDTO({
    required this.id,
    required this.user,
    required this.number,
    required this.createdAt,
  });

  factory LotteryWinnerDTO.fromJson(Map<String, dynamic> json) {
    return LotteryWinnerDTO(
      id: json['id'],
      user: User.fromJson(json['user']),
      number: json['number'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
