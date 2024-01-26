class ServiceItem {
  final String cartId;
  final String serviceName;
  final String qty;
  final String image;
  final String price;

  ServiceItem({
    required this.cartId,
    required this.serviceName,
    required this.qty,
    required this.image,
    required this.price,
  });

factory ServiceItem.fromJson(Map<String, dynamic> json) {
  return ServiceItem(
    cartId: json['cart_id'] as String,
    serviceName: json['servicename'] as String,
    qty: json['qty'] as String,
    image: json['image'] as String,
    price: json['price'] as String,
  );
}

}
