class LoginDTO {
  final String username;
  final String password;

  LoginDTO({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      username: json['username'],
      password: json['password'],
    );
  }
}
