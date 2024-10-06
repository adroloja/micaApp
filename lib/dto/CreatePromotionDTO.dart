class CreatePromotionDTO {
  final String code;
  final String email;

  CreatePromotionDTO({
    required this.code,
    required this.email,
  });

  factory CreatePromotionDTO.fromJson(Map<String, dynamic> json) {
    return CreatePromotionDTO(
      code: json['code'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'email': email,
    };
  }
}
