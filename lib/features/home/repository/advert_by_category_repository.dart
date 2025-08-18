import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/advert_by_category_model.dart';
import 'package:ilolo/services/api_service.dart';

class AdvertByCategoryRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<AdvertByCategoryModel> _advertsByCategory = [];
  List<AdvertByCategoryModel> get advertsByCategory => _advertsByCategory;

  Future<void> getAdvertsByCategory(String slug, String type) async {
    try {
      final response = await request.generalGetData(endpoint: 'adverts/$type/$slug');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _advertsByCategory = advertsByCategoryToList(body['data']['adverts']['data']);
        // print(body['data']['adverts']['data']);
      } else {
        // print("object ${response.statusCode}");
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
