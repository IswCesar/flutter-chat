import 'package:chat/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/pages/login.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/services/socket.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final socket = Provider.of<Socket>(context, listen: false);
    final islogged = await auth.isLoggedIn();
    if (islogged) {
      socket.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomePage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0),
        ),
      );
    }
  }
}
