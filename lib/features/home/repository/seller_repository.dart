import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/advert_by_category_model.dart';
import 'package:ilolo/features/home/model/seller_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class SellerRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  SellerModel? _seller;
  List<AdvertByCategoryModel>? _sellerAdverts;
  List<AdvertByCategoryModel>? get sellerAdverts => _sellerAdverts;
  SellerModel? get seller => _seller;

  Future<void> getSeller(int sellerId) async {
    try {
      final response = await request.generalGetData(endpoint: 'seller/$sellerId');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _seller = sellerData(body['data']['seller']);
        _sellerAdverts = advertsByCategoryToList(body['data']['adverts']['data']);
      } else {
        // print(response.statusCode)
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // report a single seller
  Future<void> reportSeller(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: "report", data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        // print(body);
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        var body = jsonDecode(response.body);
        // print(body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
  }
}
