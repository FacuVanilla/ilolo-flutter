class NotificationModel {
  final String id;
  final String type;
  final String notifiableType;
  final int notifiableId;
  final Map<String, dynamic> data;
  final dynamic readAt;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      data: Map<String, dynamic>.from(json['data']),
      readAt: json['read_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}