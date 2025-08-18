import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/account/repository/user_advert_repository.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class PostAdRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  String _categoryId = '';
  String _subCategoryId = '';
  String _subCategoryName = '';
  String _state = '';
  String _lga = '';
  String get state => _state;
  String get lga => _lga;
  String get categoryId => _categoryId;
  String get subCategoryId => _subCategoryId;
  String get subCategoryName => _subCategoryName;

  LoadState _loadState = LoadState.idle;
  LoadState get loader => _loadState;

  // set my loader to idle state
  void setIdle() {
    _loadState = LoadState.idle;
    notifyListeners();
  }

  // set my loader to loading state
  void setLoader() {
    _loadState = LoadState.loading;
    notifyListeners();
  }

  set state(String state) {
    _state = state;
    notifyListeners();
  }

  set lga(String lga) {
    _lga = lga;
    notifyListeners();
  }

  set categoryId(String categoryId) {
    _categoryId = categoryId;
    notifyListeners();
  }

  set subCategoryId(String subCategoryId) {
    _subCategoryId = subCategoryId;
    notifyListeners();
  }

  set subCategoryName(String subCategoryName) {
    _subCategoryName = subCategoryName;
    notifyListeners();
  }

  Future<void> postAdvert(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: 'postad', data: data);
      if (response.statusCode == 200) {
        // var body = jsonDecode(response.body);
        _state = '';
        _lga = '';
        _categoryId = '';
        _subCategoryId = '';
        _subCategoryName = '';
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getActiveAdverts();
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getReviewAdverts();
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getClosedAdverts();
        Navigator.pop(ctx);
        GoRouter.of(ctx).push('/post-success');
      } else {
        var body = jsonDecode(response.body);
        // print(body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
  }


    Future<void> upDateAdvert(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: 'updatead', data: data);
      if (response.statusCode == 200) {
        // var body = jsonDecode(response.body);
        _state = '';
        _lga = '';
        _categoryId = '';
        _subCategoryId = '';
        _subCategoryName = '';
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getActiveAdverts();
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getReviewAdverts();
        await Provider.of<UserAdvertRepository>(ctx, listen: false).getClosedAdverts();
        Navigator.pop(ctx);
        GoRouter.of(ctx).push('/update-success');
      } else {
        var body = jsonDecode(response.body);
        // print(body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
  }
}
