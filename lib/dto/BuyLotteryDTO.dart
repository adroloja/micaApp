class BuyLotteryDTO {
  String email;
  int amount;
  bool isAGift;
  String userGiftEmail;

  BuyLotteryDTO({
    required this.email,
    required this.amount,
    required this.isAGift,
    required this.userGiftEmail,
  });

  factory BuyLotteryDTO.fromJson(Map<String, dynamic> json) {
    return BuyLotteryDTO(
      email: json['email'],
      amount: json['amount'],
      isAGift: json['isAGift'],
      userGiftEmail: json['userGiftEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['amount'] = this.amount;
    data['isAGift'] = this.isAGift;
    data['userGiftEmail'] = this.userGiftEmail;
    return data;
  }
}
