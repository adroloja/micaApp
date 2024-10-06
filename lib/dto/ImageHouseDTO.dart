class ImageHouseDTO {
  final int id;
  final String? imageBase64;

  ImageHouseDTO({required this.id, this.imageBase64});

  factory ImageHouseDTO.fromJson(Map<String, dynamic> json) {
    return ImageHouseDTO(
      id: json['id'],
      imageBase64: json['imageBase64'],
    );
  }
}
