import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ilolo/app/app_storage.dart';
import 'package:flutter/material.dart';

class ApiService {
  // api request class properties
  final String url = 'https://www.ilolo.ng/api/';
  String? authToken;

  // set http request headers
  _authHeaders() =>
      {'Accept': 'application/json', 'Authorization': 'Bearer $authToken'};
  _authPostHeaders() => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken'
      };
  _generalHeaders() => {'Accept': 'application/json'};
  _generalPostHeaders() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};

  // unauthenticated get request
  Future<http.Response> generalGetData({required String endpoint}) async {
    try {
      debugPrint('GET Request to: $url$endpoint');
      final response =
          await http.get(Uri.parse(url + endpoint), headers: _generalHeaders());
      debugPrint('Response status: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('Error in GET request: $e');
      rethrow;
    }
  }

  // authenticated get request
  Future<http.Response> authGetData({required String endpoint}) async {
    try {
      authToken = await AppStorage().getAuthToken();
      debugPrint('Auth GET Request to: $url$endpoint');
      final response =
          await http.get(Uri.parse(url + endpoint), headers: _authHeaders());
      debugPrint('Response status: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('Error in Auth GET request: $e');
      rethrow;
    }
  }

  // unauthenticated post request
  Future<http.Response> generalPostData(
      {required String endpoint, required Map data}) async {
    try {
      debugPrint('POST Request to: $url$endpoint with data: $data');
      final response = await http.post(Uri.parse(url + endpoint),
          body: jsonEncode(data), headers: _generalPostHeaders());
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return response;
    } catch (e) {
      debugPrint('Error in POST request: $e');
      rethrow;
    }
  }

  // authenticated post request
  Future<http.Response> authPostData(
      {required String endpoint, required Map data}) async {
    try {
      authToken = await AppStorage().getAuthToken();
      debugPrint('Auth POST Request to: $url$endpoint with data: $data');
      final response = await http.post(Uri.parse(url + endpoint),
          body: jsonEncode(data), headers: _authPostHeaders());
      debugPrint('Response status: ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('Error in Auth POST request: $e');
      rethrow;
    }
  }
}
