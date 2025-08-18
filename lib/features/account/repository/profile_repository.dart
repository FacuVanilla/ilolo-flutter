import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_emun.dart';
import 'package:ilolo/app/app_storage.dart';
import 'package:ilolo/features/account/model/profile_model.dart';
import 'package:ilolo/services/api_service.dart';
import 'package:ilolo/services/google_signin_api_service.dart';
import 'package:ilolo/widgets/alert_widget.dart';
import 'package:provider/provider.dart';

class ProfileRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  ProfileDataModel? _profileData;
  ProfileDataModel? get profileData => _profileData;
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

  set profileData(ProfileDataModel? setProfileData) {
    _profileData = setProfileData;
    notifyListeners();
  }

  // method to request the use profile
  Future<void> getProfileData() async {
    try {
      final response = await request.authGetData(endpoint: 'profile');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _profileData = ProfileDataModel.fromJson(body['data']['profile']);
      } else if (response.statusCode == 401) {
        await AppStorage().removeAuthToken();
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to post user avater
  Future<void> postAvater(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: 'uploadavatar', data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to update profile data
  Future<void> updateProfileData(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: 'updatepersonal', data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to update business data
  Future<void> updateBusinessData(Map<String, dynamic> data, ctx) async {
    try {
      final response = await request.authPostData(endpoint: 'updatebusiness', data: data);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        await getProfileData();
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        var body = jsonDecode(response.body);
        Alert().show(ctx, message: body['message'], color: Colors.red);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  // method to delete account
  Future<void> deleteAccount(ctx) async {
    try {
      final response = await request.authGetData(endpoint: 'deleteaccount');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        // print(body);
        await AppStorage().removeAuthToken();
        try {
          await GoogleSignInService.logout();
        } catch (e) {
          // 
        }
        ProfileDataModel? newProfileData;
        Provider.of<ProfileRepository>(ctx, listen: false).profileData = newProfileData;
        GoRouter.of(ctx).pushReplacement('/home');
        Alert().show(ctx, message: body['message'], color: Colors.green);
      } else {
        // var body = jsonDecode(response.body);
        // print(body);
      }
    } on SocketException {
      //
    }
  }
}
