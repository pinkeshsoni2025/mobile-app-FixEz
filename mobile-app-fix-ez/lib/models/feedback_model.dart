class CustomerFeedback {
  final String name;
  final int rating;
  final String message;
  final String createdAt;
  

  CustomerFeedback({ required this.name,  
  required this.rating, required this.message, required this.createdAt});

  factory CustomerFeedback.fromJson(Map<String, dynamic> json) {
    return CustomerFeedback(
      name: json['name'] ?? '',
      rating: json['rating'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class HappyCustomer {
  final String id;
  final String category;
  final String subCategory;
  final String categoryId;
  final int totalCustomer;
  final int totalRaiting;
  final List<CustomerFeedback> feedbacks;

  HappyCustomer({required this.category, required this.id, required this.totalCustomer, required this.totalRaiting, required this.subCategory, required this.categoryId, required this.feedbacks});

  factory HappyCustomer.fromJson(Map<String, dynamic> json) {
    return HappyCustomer(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      category: json['category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      totalCustomer: json['total_customer'] ?? '',
      totalRaiting: json['total_raiting'] ?? '',
      feedbacks: (json['feedbacks'] as List)
          .map((feedback) => CustomerFeedback.fromJson(feedback))
          .toList(),
    );
  }
}
