class Service {
  final String serviceId;
  final String serviceName;
  final String serviceImage;

  Service({
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      serviceImage: json['service_image'],
    );
  }
}
