import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/advert_model.dart';
import 'package:ilolo/features/home/model/special_advert_model.dart';
import 'package:ilolo/services/api_service.dart';

class AdvertRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  List<AdvertModel> _adverts = [];
  List<SpecialAdvertModel> _specialAdverts = [];
  List<AdvertModel> get adverts => _adverts;
  List<SpecialAdvertModel> get specialAdverts => _specialAdverts;

  // fetch adverts data from endpoint
  Future getAdverts() async {
    try {
      final response = await request.generalGetData(endpoint: 'adverts');
      var body = jsonDecode(response.body);
      // print(body);
      _adverts = advertsToList(body['data']['adverts']['data']);
      _specialAdverts = specialAdvertsToList(body['data']['special']['data']);
      _isLoaded = true;
      notifyListeners();
    } on SocketException {
      // print('no network');
    }
    notifyListeners();
  }
}
