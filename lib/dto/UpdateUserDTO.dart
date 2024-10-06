class UpdateUserDTO {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  UpdateUserDTO({this.id, this.firstName, this.lastName, this.email});

  factory UpdateUserDTO.fromJson(Map<String, dynamic> json) {
    return UpdateUserDTO(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json["email"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email
    };
  }
}
