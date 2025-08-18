import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_storage.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/services/google_signin_api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class LoginRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  LoadState _loadState = LoadState.idle;
  LoadState get loader => _loadState;

  bool _googleStatus = false;
  bool get googleStatus => _googleStatus;

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

  // preform api call to attempt login
  Future<void> loginAttempt(Map data, ctx) async {
    try {
      final response =
          await request.generalPostData(endpoint: "login", data: data);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await AppStorage().saveAuthToken(body['data']['token']);
        await Provider.of<ProfileRepository>(ctx, listen: false)
            .getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
        GoRouter.of(ctx).go('/home');
      } else {
        // Handle any error status code
        String errorMessage =
            body['message'] ?? 'Login failed. Please try again.';
        Alert().show(ctx, message: errorMessage, color: Colors.red);
      }
    } on SocketException {
      // Handle network errors
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
    } catch (e) {
      // Handle other unexpected errors
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
    }
    notifyListeners();
  }

  // preform api call to attempt login with google data
  Future<void> googleLoginAttempt(Map data, ctx) async {
    try {
      debugPrint('Attempting Google login with data: ${data.toString()}');
      final response =
          await request.generalPostData(endpoint: "auth/google", data: data);
      debugPrint('Google login response status: ${response.statusCode}');

      var body = jsonDecode(response.body);
      debugPrint('Google login response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Google login successful, saving token');
        await AppStorage().saveAuthToken(body['data']['token']);
        await Provider.of<ProfileRepository>(ctx, listen: false)
            .getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
        GoRouter.of(ctx).go('/home');
      } else {
        await GoogleSignInService.logout();
        String errorMessage =
            body['message'] ?? 'Google login failed. Please try again.';
        debugPrint('Google login failed with message: $errorMessage');
        Alert().show(ctx, message: errorMessage, color: Colors.red);
      }
    } on SocketException {
      // Handle network errors
      debugPrint('Google login network error: SocketException');
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
      await GoogleSignInService.logout();
    } catch (e) {
      // Handle other unexpected errors
      debugPrint('Google login unexpected error: $e');
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
      await GoogleSignInService.logout();
    }
    notifyListeners();
  }

  Future<void> googleAuthCheck() async {
    try {
      final response = await request.generalGetData(endpoint: 'google/status');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        // print(body['data']['enabled']);
        _googleStatus = body['data']['enabled'];
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
