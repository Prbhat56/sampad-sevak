class ServiceItem {
  final String serviceName;
  final String price;
  final String total;
  final String imagePath;

  ServiceItem({
    required this.serviceName,
    required this.price,
    required this.total,
    required this.imagePath,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceName: json['servicename'] ?? 'Unknown Service',
      price: 'Rs. ${json['price']} X ${json['qty']}',
      total: 'Total: Rs. ${(json['price'] as int) * (json['qty'] as int)}',
      imagePath: 'https://path-to-your-images/${json['image']}', 
    );
  }
}
