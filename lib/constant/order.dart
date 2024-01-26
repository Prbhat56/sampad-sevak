class Order {
  String status;
  String orderId;
  DateTime scheduleDate;
  String scheduleTime;
  DateTime orderDate;
  String technicianName;
  String contactNumber;
  int quantity;
  double price;
  double total;
  double discount;
  double gst;
  double grandTotal;
  double paidAmount;
  String address;
  String city;
  String state;
  String pincode;
  String otp;

  Order({
    required this.status,
    required this.orderId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.orderDate,
    required this.technicianName,
    required this.contactNumber,
    required this.quantity,
    required this.price,
    required this.total,
    required this.discount,
    required this.gst,
    required this.grandTotal,
    required this.paidAmount,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.otp,
  });
    factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      status: json['status'] as String,
      orderId: json['orderId'] as String,
      scheduleDate: DateTime.parse(json['scheduleDate'] as String),
      scheduleTime: json['scheduleTime'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      technicianName: json['technicianName'] as String,
      contactNumber: json['contactNumber'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      gst: (json['gst'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      pincode: json['pincode'] as String,
      otp: json['otp'] as String,
    );
  }
}
