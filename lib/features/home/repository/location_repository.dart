import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/location_model.dart';
import 'package:ilolo/services/api_service.dart';

class LocationRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<StateDataModel> _states = [];
  List<StateDataModel> get states => _states;

  // fetch location data from endpoint
  Future<void> getStateAndLga() async {
    try {
      final response = await request.generalGetData(endpoint: 'location');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> stateDataList = body['data'];
        _states = stateDataList.map((stateData) => StateDataModel.fromJson(stateData)).toList();
      }else{}
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
