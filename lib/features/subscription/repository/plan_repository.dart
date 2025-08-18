import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/subscription/model/plan_model.dart';
import 'package:ilolo/services/api_service.dart';

class PlanRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  PlanData? _plans;
  PlanData? get plans => _plans;

  Future<void> getPlans() async {
    try {
      final response = await request.generalGetData(endpoint: 'plans');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _plans = planDataFromJson(body['data']);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
