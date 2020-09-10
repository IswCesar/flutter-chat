import 'package:chat/models/message_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/models/user.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth.dart';

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Msg>> getChat(String userID) async {
    final rsp = await http.get(
      '${Environment.apiUrl}/messages/$userID',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await Auth.getToken()
      },
    );

    final messageResponse = messageResponseFromJson(rsp.body);
    return messageResponse.msg;
  }
}
