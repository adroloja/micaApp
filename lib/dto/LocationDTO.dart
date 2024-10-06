class PositionDTO {
  String email;
  double lat;
  double lng;

  PositionDTO({
    required this.email,
    required this.lat,
    required this.lng,
  });

  factory PositionDTO.fromJson(Map<String, dynamic> json) {
    return PositionDTO(
      email: json['email'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'lat': lat,
      'lng': lng,
    };
  }
}
