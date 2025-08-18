import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/auth/view/verify_phone_otp.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class VerifyNumberEmailRepository extends ChangeNotifier {
  final ApiService request = ApiService();

  // phone number sms otp [request]
  Future<void> requestSmsOtp({required String phoneNumber, required ctx}) async {
    try {
      final response = await request.authPostData(endpoint: 'phoneotp', data: {'phone': phoneNumber});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => VerifyPhoneOtpScreen(phoneNumber: phoneNumber)));
        // print(body);
        Alert().show(ctx, message: body['message']);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // phone number voice call otp [request]
  Future<void> requestVoiceOtp({required String phoneNumber, required ctx}) async {
    try {
      final response = await request.authPostData(endpoint: 'voiceotp', data: {'phone': phoneNumber});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => VerifyPhoneOtpScreen(phoneNumber: phoneNumber)));
        // print(body);
        Alert().show(ctx, message: body['message']);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // verify phone number otp [request]
  Future<void> verifyPhoneOtp({required String phoneNumber, required otp, required ctx}) async {
    try {
      final response = await request.authPostData(endpoint: 'phoneverify', data: {'phone': phoneNumber, 'otp': otp});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await Provider.of<ProfileRepository>(ctx).getProfileData();
        GoRouter.of(ctx).go('/home');
        // print(body);
        Alert().show(ctx, message: body['message']);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message']);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
