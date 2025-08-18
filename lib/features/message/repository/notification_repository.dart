import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/message/model/notification_model.dart';
import 'package:ilolo/services/api_service.dart';

class NotificationRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> getNotifications() async {
    try {
      final response = await request.authGetData(endpoint: "notifications");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        final List<dynamic> notificationsData = body['data']['notifications'];
        _notifications = notificationsData.map((notificationJson) => NotificationModel.fromJson(notificationJson)).toList();
        // print(_notification);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
