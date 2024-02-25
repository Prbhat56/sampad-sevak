class Address {
  final String addressId;
  final String userId;
  final String firstName;
  final String? lastName;
  final String cityname;
  final String state;
  final String pincode;
  final String email;
  final String number;
  final String address1;
  final String address2;
  final String isDelete;
  final String? lat;
  final String? lng;
  final String createdDate;
  final String updatedDate;
  final String cityId;
  final String cityName;
  final String status;

  Address({
    required this.addressId,
    required this.userId,
    required this.firstName,
    this.lastName,
    required this.cityname,
    required this.state,
    required this.pincode,
    required this.email,
    required this.number,
    required this.address1,
    required this.address2,
    required this.isDelete,
    this.lat,
    this.lng,
    required this.createdDate,
    required this.updatedDate,
    required this.cityId,
    required this.cityName,
    required this.status,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id'] ?? '',
      userId: json['user_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      cityname: json['cityname'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      email: json['email'] ?? '',
      number: json['number'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['adress2'] ?? '',
      isDelete: json['is_delte'] ?? '',
      lat: json['lat'],
      lng: json['lng'],
      createdDate: json['created_date'] ?? '',
      updatedDate: json['updatd_dare'] ?? '',
      cityId: json['city_id'] ?? '',
      cityName: json['city_name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}