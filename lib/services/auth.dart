import 'dart:convert';

import 'package:chat/models/register_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';

class Auth with ChangeNotifier {
  User user;
  bool _authenticating = false;
  bool _registering = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get authenticating => this._authenticating;
  set authenticating(bool value) {
    this._authenticating = value;
    notifyListeners();
  }

  bool get registering => this._registering;
  set registering(bool value) {
    this._registering = value;
    notifyListeners();
  }

  // Getter del token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authenticating = true;
    String uri = '${Environment.apiUrl}/login';

    final data = {'email': email, 'password': password};
    final rsp = await http.post(Uri.parse(uri),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.authenticating = false;
    if (rsp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(rsp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.registering = true;
    String uri = '${Environment.apiUrl}/login/new';
    final data = {'name': name, 'email': email, 'password': password};
    final rsp = await http.post(Uri.parse(uri),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.registering = false;
    if (rsp.statusCode == 200 || rsp.statusCode == 201) {
      final registerResponse = registerResponseFromJson(rsp.body);
      this.user = registerResponse.user;
      await this._saveToken(registerResponse.token);
      return true;
    } else {
      final rspBody = jsonDecode(rsp.body);
      return rspBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    String uri = '${Environment.apiUrl}/login/renew';
    final token = await _storage.read(key: 'token');
    print(token);
    final rsp = await http.get(Uri.parse(uri),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    if (rsp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(rsp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    // Write value in storage
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
