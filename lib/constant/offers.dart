class Offer {
  final String offerId;
  final String name;
  final String imageUrl;

  Offer({
    required this.offerId,
    required this.name,
    required this.imageUrl,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerId: json['coupon_code_id'],
      name: json['name'],
      imageUrl: json['img'],
    );
  }
}
