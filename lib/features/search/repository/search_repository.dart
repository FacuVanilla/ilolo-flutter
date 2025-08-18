import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/search/model/advert_search_model.dart';
import 'package:ilolo/services/api_service.dart';

class SearchRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<AdvertSearchModel> _advertSearchResults = [];
  List<AdvertSearchModel> get advertSearchResult => _advertSearchResults;

  Future<void> searchAdverts(String searchTerm) async {
    try {
      final response = await request.generalGetData(endpoint: 'adverts/search?q=$searchTerm');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _advertSearchResults = advertsToList(body['data']['adverts']['data']);
      } else {
        // print("object ${response.statusCode}");
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
