import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ilolo/features/subscription/model/subscription_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class SubscriptionRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<SubscriptionModel> _subscriptions = [];
  List<SubscriptionModel> get subscriptions => _subscriptions;

  Future<void> getSubscriptions() async {
    try {
      final response = await request.authGetData(endpoint: "subscriptions");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _subscriptions = (body['data']['subscriptions']['data'] as List).map((e) => SubscriptionModel.fromJson(e)).toList();
      }
    } on SocketException {
      //
    }
  }

  Future<void> makeSubscription(ctx, planId, ref) async {
    try {
      final response = await ApiService().authPostData(endpoint: 'transaction/verify', data: {'plan_id': planId, 'reference': ref});
      if (response.statusCode == 200) {
        // var body = jsonDecode(response.body);
        // print(body);
        await getSubscriptions();
      } else {
        var body = jsonDecode(response.body);
        // print(body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
