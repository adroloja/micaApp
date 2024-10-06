class UserGoogleInfo {
  final String sub;
  final String name;
  final String givenName;
  final String picture;
  final String email;
  final bool emailVerified;

  UserGoogleInfo({
    required this.sub,
    required this.name,
    required this.givenName,
    required this.picture,
    required this.email,
    required this.emailVerified,
  });

  factory UserGoogleInfo.fromJson(Map<String, dynamic> json) {
    return UserGoogleInfo(
      sub: json['sub'] ?? '',
      name: json['name'] ?? '',
      givenName: json['given_name'] ?? '',
      picture: json['picture'] ?? '',
      email: json['email'] ?? '',
      emailVerified: json['email_verified'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserInfo{sub: $sub, name: $name, givenName: $givenName, '
        'picture: $picture, email: $email, emailVerified: $emailVerified}';
  }
}
