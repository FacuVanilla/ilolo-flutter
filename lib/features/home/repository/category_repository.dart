import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/home/model/category_model.dart';
import 'package:ilolo/services/api_service.dart';

class CategoryRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  // fetch categories data from endpoint
  Future<void> getCategories() async {
    try {
      final response = await request.generalGetData(endpoint: 'categories');
      var body = jsonDecode(response.body);
      _categories = categoryToList(body['data']);
      notifyListeners();
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
