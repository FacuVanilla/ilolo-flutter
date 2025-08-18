import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/features/book_mark/model/book_mark_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class BookMarkRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  LoadState _loadState = LoadState.idle;
  LoadState get loader => _loadState;
  List<BookMarkDataModel> _bookMarkAdverts = [];
  List<BookMarkDataModel> get bookMarkAdverts => _bookMarkAdverts;
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

  // method to add bookmark items
  Future<void> addBookmark(Map data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: "bookmarks/add", data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getBookMarks();
        Alert().show(ctx, message: body['message'], color: Colors.lightGreenAccent);
      } else {
        // print('response.statusCode');
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to get the bookmark adverts
  Future<void> getBookMarks() async {
    try {
      final response = await request.authGetData(endpoint: "bookmarks");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<dynamic> bookMarkJsonList = body['data']['bookmarks']['data'];
        _bookMarkAdverts = bookMarkJsonList.map((e) => BookMarkDataModel.fromJson(e)).toList();
      } else {
        //
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to remove from bookmark
  Future<void> removeBookMark(Map data, ctx)async{
    try{
      final response = await request.authPostData(endpoint: "bookmarks/remove", data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getBookMarks();
        Alert().show(ctx, message: body['message'], color: Colors.lightGreenAccent);
      } else {
        // print('response.statusCode');
      }
    }on SocketException{
      // 
    }
    notifyListeners();
  }
}
