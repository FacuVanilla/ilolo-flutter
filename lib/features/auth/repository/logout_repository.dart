import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_storage.dart';
import 'package:ilolo/features/account/model/profile_model.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/services/google_signin_api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class LogoutRepository extends ChangeNotifier {
  final ApiService request = ApiService();
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

  // preform api call to attempt logout
  Future<void> attempt(ctx) async {
    try {
      final response = await request.authPostData(endpoint: "logout", data: {});
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await AppStorage().removeAuthToken();
        try {
          await GoogleSignInService.logout();
        } catch (e) {
          // 
        }
        ProfileDataModel? newProfileData;
        Provider.of<ProfileRepository>(ctx, listen: false).profileData = newProfileData;
        GoRouter.of(ctx).pushReplacement('/home').whenComplete(() => Alert().show(ctx, message: body['message'], color: Colors.green));
        // Alert().show(ctx, message: body['message'], color: Colors.green);
      } else{
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
