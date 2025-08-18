import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/advert_by_location_model.dart';
import 'package:ilolo/services/api_service.dart';

class AdvertByLocationRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<AdvertByLocationModel> _advertsByLocation = [];
  List<AdvertByLocationModel> get advertsByLocation => _advertsByLocation;

  Future<void> getAdvertsByLocation(String name, String location) async {
    try {
      final response = await request.generalGetData(endpoint: 'adverts/$location/$name');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _advertsByLocation = advertsByLocationToList(body['data']['adverts']['data']);
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
