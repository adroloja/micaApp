class LotteryNumberDTO {
  final int number;
  final String usernameOwner;
  final String usernameGift;
  final bool gift;
  final DateTime createdDate;

  LotteryNumberDTO({
    required this.number,
    required this.usernameOwner,
    required this.usernameGift,
    required this.gift,
    required this.createdDate,
  });

  factory LotteryNumberDTO.fromJson(Map<String, dynamic> json) {
    return LotteryNumberDTO(
      number: json['number'],
      usernameOwner: json['usernameOwner'],
      usernameGift: json['usernameGift'] ?? '',
      gift: json['gift'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'usernameOwner': usernameOwner,
      'usernameGift': usernameGift,
      'gift': gift,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}
