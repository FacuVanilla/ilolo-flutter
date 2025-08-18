import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/single_advert_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class SingleAdvertRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  SingleAdvertModel? _singleAdvert;
  SingleAdvertModel? get singleAdvert => _singleAdvert;

  // request for single advert
  Future<void> getSingleAdvert(int advertId) async {
    try {
      final response = await request.generalGetData(endpoint: 'advert/$advertId');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _singleAdvert = singleAdvertToList(body['data']['advert']);
      } else {
        //
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // make an advert as unavailable
  Future<void> unavailable(String advertId, ctx) async {
    try {
      final response = await request.authPostData(endpoint: "unavailable", data: {'advert_id': advertId});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        Navigator.pop(ctx);
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
  }
}
