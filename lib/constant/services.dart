class Category {
  final String catId;
  final String catName;
  final String catImage;

  Category({
    required this.catId,
    required this.catName,
    required this.catImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      catId: json['cat_id'],
      catName: json['cat_name'],
      catImage: json['cat_img'],
    );
  }
}
