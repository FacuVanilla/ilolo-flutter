import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_storage.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/auth/auth.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class RegisterRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  LoadState _loadState = LoadState.idle;
  LoadState get loader => _loadState;

  EmailValidateState _validateState = EmailValidateState.sendOtpMail;
  EmailValidateState get validateState => _validateState;
  set validateState(EmailValidateState validateState) {
    _validateState = validateState;
    notifyListeners();
  }

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

  Future<void> sendEmailOtp(String email, ctx) async {
    try {
      final response = await request
          .generalPostData(endpoint: 'emailotp', data: {'email': email});
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Alert().show(ctx, message: body['message'], color: Colors.green);
        _validateState = EmailValidateState.validateWithOtp;
      } else {
        String errorMessage =
            body['message'] ?? 'Failed to send OTP. Please try again.';
        Alert().show(ctx, message: errorMessage, color: Colors.red);
        debugPrint('OTP send error: ${response.statusCode} - $errorMessage');
      }
    } on SocketException {
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
      debugPrint('OTP send network error: SocketException');
    } catch (e) {
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
      debugPrint('OTP send general error: $e');
    }
    notifyListeners();
  }

  Future<void> verifyEmailOtp(String email, String otp, ctx) async {
    try {
      final response = await request.generalPostData(
          endpoint: 'verifyemail', data: {'email': email, 'otp': otp});
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Alert().show(ctx, message: body['message'], color: Colors.green);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (ctx) => RegisterScreen(email: email)));
      } else {
        String errorMessage =
            body['message'] ?? 'Failed to verify OTP. Please try again.';
        Alert().show(ctx, message: errorMessage, color: Colors.red);
        debugPrint(
            'OTP verification error: ${response.statusCode} - $errorMessage');
      }
    } on SocketException {
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
      debugPrint('OTP verification network error: SocketException');
    } catch (e) {
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
      debugPrint('OTP verification general error: $e');
    }
    notifyListeners();
  }

  Future<void> register(Map data, ctx) async {
    try {
      final response =
          await request.generalPostData(endpoint: "register", data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await AppStorage().saveAuthToken(body['data']['token']);
        await Provider.of<ProfileRepository>(ctx, listen: false)
            .getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
        GoRouter.of(ctx).go('/home');
      } else if (response.statusCode == 422) {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
