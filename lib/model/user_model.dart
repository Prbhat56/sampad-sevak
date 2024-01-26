class UserData {
  final String? id;
  final String? full_name;
  final String? email;
  final String? contact_no;
  final String? profile_image;

 UserData({this.id, this.full_name, this.email, this.contact_no, this.profile_image});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      full_name: json['full_name'],
      email: json['email'],
      contact_no: json['contact_no'],
      profile_image: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': full_name??"",
      'email': email??"",
      'contact_no': contact_no??"",
      'profile_image': profile_image??"",
    };
  }
}

