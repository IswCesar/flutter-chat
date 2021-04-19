import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      // ? "http://10.0.2.2:3000/api"
      ? "http://192.168.1.92:3000/api"
      : 'http://localhost:3000/api';

  static String audioUrl = "http://192.168.1.92:3000/uploads";

  static String uploadUrl = "http://192.168.1.92:3000/uploads";

  static String socketUrl =
      // Platform.isAndroid ? "http://10.0.2.2:3000" : 'http://localhost:3000';
      Platform.isAndroid ? "http://192.168.1.92:3000" : 'http://localhost:3000';
}
