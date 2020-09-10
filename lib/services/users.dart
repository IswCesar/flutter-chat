import 'package:chat/models/users_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat/global/environment.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth.dart';

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final rsp = await http.get('${Environment.apiUrl}/users/', headers: {
        'Content-Type': 'application/json',
        'x-token': await Auth.getToken()
      });
      final userResponse = userResponseFromJson(rsp.body);
      return userResponse.users;
    } catch (error) {
      return [];
    }
  }
}
