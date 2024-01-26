class Service {
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  final String amount; // Assuming you need the price as well

  Service({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.amount, 
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      serviceImage: json['service_image'],
      amount: json['amount'], // Parsing the amount
    );
  }
}
