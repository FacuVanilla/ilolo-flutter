import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ilolo/features/message/model/contact_model.dart';
import 'package:ilolo/services/api_service.dart';

class ContactRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<ContactModel> _contacts = [];
  List<ContactModel> get contacts => _contacts;

  List<ContactModel> _blockedContacts = [];
  List<ContactModel> get blockedContacts => _blockedContacts;

  Future<void> getContacts() async {
    try {
      final response = await request.authGetData(endpoint: 'contacts');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        _contacts = (body['data']['contacts'] as List).map((e) => ContactModel.fromJson(e)).toList();
        // print(_contacts);
        await getBlockContacts();
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> blockContact(context, contactId) async {
    try {
      final response = await request.authPostData(endpoint: 'blockcontact', data: {'user_id': contactId});
      if (response.statusCode == 200) {
        await getContacts();
        await getBlockContacts();
        // var body = jsonDecode(response.body);
        // print(body);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> getBlockContacts() async {
    try {
      final response = await request.authGetData(endpoint: 'blockedcontacts');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        // print(body);
        _blockedContacts = (body['data']['contacts'] as List).map((e) => ContactModel.fromJson(e)).toList();
        // print(_contacts);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

    Future<void> unBlockContact(context, contactId) async {
    try {
      final response = await request.authPostData(endpoint: 'unblockcontact', data: {'user_id': contactId});
      if (response.statusCode == 200) {
        await getContacts();
        await getBlockContacts();
        // var body = jsonDecode(response.body);
        // print(body);
        Navigator.pop(context);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
