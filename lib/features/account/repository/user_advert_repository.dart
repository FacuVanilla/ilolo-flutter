import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/account/model/user_advert_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class UserAdvertRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<UserAdvertModel> _activeAdverts = [];
  List<UserAdvertModel> _reviewAdverts = [];
  List<UserAdvertModel> _closedAdverts = [];
  List<UserAdvertModel> get activeAdverts => _activeAdverts;
  List<UserAdvertModel> get reviewAdverts => _reviewAdverts;
  List<UserAdvertModel> get closedAdverts => _closedAdverts;

  Future<void> closeActiveAdverts(advertId, ctx) async {
    try {
      final response = await request.authPostData(endpoint: "closead", data: {'advert_id': advertId});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getActiveAdverts();
        await getReviewAdverts();
        await getClosedAdverts();
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
         var body = jsonDecode(response.body);
         Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> getActiveAdverts() async {
    try {
      final response = await request.authGetData(endpoint: "ads/active");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> jsonData = body['data']['adverts']['data'] as List;
        _activeAdverts = jsonData.map((e) => UserAdvertModel.fromJson(e)).toList();
      } else {
        //
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> getReviewAdverts() async {
    try {
      final response = await request.authGetData(endpoint: "ads/review");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> jsonData = body['data']['adverts']['data'] as List;
        _reviewAdverts = jsonData.map((e) => UserAdvertModel.fromJson(e)).toList();
      } else {
        //
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> getClosedAdverts() async {
    try {
      final response = await request.authGetData(endpoint: "ads/closed");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> jsonData = body['data']['adverts']['data'] as List;
        _closedAdverts = jsonData.map((e) => UserAdvertModel.fromJson(e)).toList();
      } else {
        //
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
