import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';

class ResetPasswordRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  LoadState _loadState = LoadState.idle;
  LoadState get loader => _loadState;

  ResetState _resetState = ResetState.sendOtpMail;
  ResetState get resetState => _resetState;
  set resetState(ResetState resetState) {
    _resetState = resetState;
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

  // send password reset otp code to the user email
  Future<void> passwordOtp({required Map data, required ctx}) async {
    try {
      final response =
          await request.generalPostData(endpoint: "passwordotp", data: data);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Alert().show(ctx, message: body['message'], color: Colors.green);
        _resetState = ResetState.resetWithOtp;
      } else {
        String errorMessage = body['message'] ??
            'Failed to send password reset OTP. Please try again.';
        Alert().show(ctx, message: errorMessage, color: Colors.red);
        debugPrint(
            'Password OTP send error: ${response.statusCode} - $errorMessage');
      }
    } on SocketException {
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
      debugPrint('Password OTP send network error: SocketException');
    } catch (e) {
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
      debugPrint('Password OTP send general error: $e');
    }
    notifyListeners();
  }

  // reset a new password for the user
  Future<void> resetPassword({required Map data, required ctx}) async {
    try {
      final response =
          await request.generalPostData(endpoint: "resetpassword", data: data);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Alert().show(ctx, message: body['message'], color: Colors.green);
        _resetState = ResetState.sendOtpMail;
        // GoRouter.of(ctx).pop();
      } else {
        String errorMessage =
            body['message'] ?? 'Failed to reset password. Please try again.';
        Alert().show(ctx, message: errorMessage, color: Colors.red);
        debugPrint(
            'Password reset error: ${response.statusCode} - $errorMessage');
      }
    } on SocketException {
      Alert().show(ctx,
          message: 'Network error. Please check your connection.',
          color: Colors.red);
      debugPrint('Password reset network error: SocketException');
    } catch (e) {
      Alert().show(ctx,
          message: 'An error occurred: ${e.toString()}', color: Colors.red);
      debugPrint('Password reset general error: $e');
    }
    notifyListeners();
  }
}
