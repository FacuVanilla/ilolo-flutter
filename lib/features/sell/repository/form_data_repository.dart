import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ilolo/features/sell/model/form_data_model.dart';
import 'package:ilolo/services/api_service.dart';

class FormDataRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<FormDataCategoryModel> _formDataCategories = [];
  List<FormDataCategoryModel> get formDataCategories => _formDataCategories;

  // fetch form data from the internet
  Future<void> getFormData() async {
    try {
      final response = await request.authGetData(endpoint: 'formdata');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _formDataCategories = formDataToList(body['data']['formdata']);
        // print(_formDataCategories);
      } else {}
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
