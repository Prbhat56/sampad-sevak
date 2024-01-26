class Subcategory {
  final String catId;
  final String catName;
  final String catImg;

  Subcategory({
    required this.catId,
    required this.catName,
    required this.catImg,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      catId: json['cat_id'],
      catName: json['cat_name'],
      catImg: json['cat_img'],
    );
  }
}
