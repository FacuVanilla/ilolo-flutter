class Plan {
  final int id;
  final String categoryType;
  final String icon;
  final String title;
  final double price;
  final int discount;
  final int duration;
  final String status;
  final String createdAt;
  final String updatedAt;

  Plan({
    required this.id,
    required this.categoryType,
    required this.icon,
    required this.title,
    required this.price,
    required this.discount,
    required this.duration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      categoryType: json['category_type'],
      icon: json['icon'],
      title: json['title'],
      price: json['price'].toDouble(),
      discount: json['discount'],
      duration: json['duration'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class SubscriptionModel {
  final int id;
  final int planId;
  final int userId;
  final String status;
  final int duration;
  final int expires;
  final String createdAt;
  final String updatedAt;
  final int userNotified;
  final Plan plan;

  SubscriptionModel({
    required this.id,
    required this.planId,
    required this.userId,
    required this.status,
    required this.duration,
    required this.expires,
    required this.createdAt,
    required this.updatedAt,
    required this.userNotified,
    required this.plan,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      planId: json['plan_id'],
      userId: json['user_id'],
      status: json['status'],
      duration: json['duration'],
      expires: json['expires'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userNotified: json['user_notified'],
      plan: Plan.fromJson(json['plan']),
    );
  }
}
