import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class ReviewRepository extends ChangeNotifier {
  final ApiService request = ApiService();

  // sending review
  Future<void> sendReview(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: "addreview", data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.lightGreenAccent);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
