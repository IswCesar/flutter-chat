import 'dart:io';

import 'package:chat/models/image_response.dart';
import 'package:chat/models/message_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/models/user.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth.dart';

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Msg>> getChat(String userID) async {
    final uri = '${Environment.apiUrl}/messages/$userID';
    final rsp = await http.get(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json',
        'x-token': await Auth.getToken()
      },
    );

    final messageResponse = messageResponseFromJson(rsp.body);
    return messageResponse.msg;
  }

  Future<ImageResponse> uploadAudio(String file, String name) async {
    try {
      print('upload service called');
      final uri = "${Environment.apiUrl}/uploads/audios";

      final rsp = http.MultipartRequest('POST', Uri.parse(uri));

      // final rsp = await http.get(Uri.parse(uri), headers: {
      //   'Content-Type': 'application/json',
      //   'x-token': await Auth.getToken()
      // });

      rsp.files.add(http.MultipartFile(
          'file', File(file).readAsBytes().asStream(), File(file).lengthSync(),
          filename: file.split("/").last));
      final res = await rsp.send();
      final respStr = await res.stream.bytesToString();
      final imageResponse = imageResponseFromJson(respStr);
      return imageResponse;
    } catch (error) {
      print(error);
      return null;
    }
  }

  uploadFile(String file, String name) async {
    try {
       final uri = "${Environment.apiUrl}/uploads/videos";
       final rsp = http.MultipartRequest('POST', Uri.parse(uri));
       rsp.files.add(http.MultipartFile(
          'file', File(file).readAsBytes().asStream(), File(file).lengthSync(),
          filename: file.split("/").last));
      final res = await rsp.send();
      final respStr = await res.stream.bytesToString();
      final imageResponse = imageResponseFromJson(respStr);
      return imageResponse;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
