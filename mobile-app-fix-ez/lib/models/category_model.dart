class Category {
  //final int albumId;
  final String id;
  final String name;
  final String? icon;
  final List sub_category;

  const Category({
    // required this.albumId,
    required this.id,
    required this.name,
    this.icon,
    required this.sub_category,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      // albumId: json['albumId'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      sub_category: json['sub_category'] as List,
    );
  }
}

