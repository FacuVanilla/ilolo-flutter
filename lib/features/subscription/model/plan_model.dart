// Dart class for the properties within each plan
class PlanProperties {
  final int id;
  final int planId;
  final int count;
  final int autoRenew;
  final bool sms;
  final String? badge;
  final bool links;
//   final String createdAt;
//   final String updatedAt;

  PlanProperties({
    required this.id,
    required this.planId,
    required this.count,
    required this.autoRenew,
    required this.sms,
    required this.badge,
    required this.links,
//     required this.createdAt,
//     required this.updatedAt,
  });
}

// Dart class for each plan
class Plan {
  final int id;
  final String categoryType;
  final String? tag;
  final String icon;
  final String title;
  final int price;
  final int discount;
  final int duration;
  final String status;
  final String createdAt;
  final String updatedAt;
  final PlanProperties properties;

  Plan({
    required this.id,
    required this.categoryType,
    required this.tag,
    required this.icon,
    required this.title,
    required this.price,
    required this.discount,
    required this.duration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.properties,
  });
}

// Dart class to represent the entire data structure
class PlanData {
  final List<Plan> land;
  final List<Plan> cars;
  final List<Plan> others;

  PlanData({
    required this.land,
    required this.cars,
    required this.others,
  });
}

  PlanProperties propertiesFromJson(Map<String, dynamic> json) {
    return PlanProperties(
      id: json['id'],
      planId: json['plan_id'],
      count: json['count'],
      autoRenew: json['autorenew'],
      sms: json['sms'],
      badge: json['badge'],
      links: json['links'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
    );
  }
  Plan planFromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      categoryType: json['category_type'],
      tag: json['tag'],
      icon: json['icon'],
      title: json['title'],
      price: json['price'],
      discount: json['discount'],
      duration: json['duration'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      properties: propertiesFromJson(json['properties']),
    );
  }
  PlanData planDataFromJson(Map<String, dynamic> json) {
    return PlanData(
      land: (json['plans']['land'] as List).map((e) => planFromJson(e)).toList(),
      cars: (json['plans']['cars'] as List).map((e) => planFromJson(e)).toList(),
      others: (json['plans']['others'] as List).map((e) => planFromJson(e)).toList(),
    );
  }

