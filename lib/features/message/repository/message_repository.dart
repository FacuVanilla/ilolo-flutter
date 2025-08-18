import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ilolo/features/message/model/message_model.dart';
import 'package:ilolo/features/message/repository/contact_repository.dart';
import 'package:ilolo/services/api_service.dart';

class MessageRepository extends ChangeNotifier {
  final ApiService request = ApiService();
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  Future<void> getMessages(int userId) async {
    try {
      final response = await request.authGetData(endpoint: "messages/$userId");
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        final messageData = body['data']['messages'];
        _messages = (messageData as List).map((e) => MessageModel.fromJson(e)).toList();
        await markMessagesAsRead(userId);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> markMessagesAsRead(int userId) async {
    try {
      final response = await request.authPostData(endpoint: "markmessageasseen", data: {'user_id': userId});
      if (response.statusCode == 200) {
        await ContactRepository().getContacts();
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

    Future<void> deleteMessage(context, contactId) async {
    try {
      final response = await request.authPostData(endpoint: 'deletechat', data: {'user_id': contactId});
      if (response.statusCode == 200) {
        await ContactRepository().getContacts();
        await ContactRepository().getBlockContacts();
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }

  Future<void> sendMessage({required int toId, required String message, required String? advertId, required ctx}) async {
    Map<String, dynamic> data = {'to_id': toId.toString(), 'message': message, 'advert_id': advertId};
    try {
      final response = await request.authPostData(endpoint: "sendmessage", data: data);
      if (response.statusCode == 200) {
        await getMessages(toId);
        await ContactRepository().getContacts();
        // print(jsonDecode(response.body));
      }
    } on SocketException {
      //
    }
    notifyListeners();
  }
}
