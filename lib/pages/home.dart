import 'package:chat/global/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/services/users.dart';
import 'package:chat/services/socket.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userService = UserService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final socket = Provider.of<Socket>(context);
    final user = auth.user;
    final colors = ColorApp();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.inputColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: "Geometric-212-BkCn-BT",
                      color: colors.title,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 15.0),
              child: IconButton(
                icon: (socket.serverStatus == ServerStatus.Online)
                    ? Icon(
                        Icons.brightness_1,
                        color: Colors.green[400],
                        size: 30.0,
                      )
                    : Icon(
                        Icons.brightness_1,
                        color: Colors.red[400],
                      ),
                onPressed: null,
              ),
            ),
          ],
        ),
        elevation: 1,
        leading: IconButton(
          color: colors.title,
          icon: Icon(Icons.menu),
          onPressed: () {
            return null;
          }, // omitting onPressed makes the button disabled
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              child: Image.asset(
                'assets/common/exit_button.png',
                fit: BoxFit.contain,
                height: 32,
                width: 28.0,
              ),
              onTap: () {
                socket.disconnect();
                Navigator.pushReplacementNamed(context, 'login');
                Auth.deleteToken();
              },
            ),
          ),
        ],
      ),
      backgroundColor: colors.homeBG,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 60.0,
                ),
                Text(
                  'My groups'.toUpperCase(),
                  style: TextStyle(
                    fontFamily: "Geometric-415-Black-BT",
                    fontSize: 40.0,
                    color: colors.titleHome,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  child: Image.asset('assets/home/basic_button.png',
                      width: MediaQuery.of(context).size.width * 0.8),
                  onTap: () {
                    Navigator.pushNamed(context, 'users');
                  },
                ),
                Image.asset('assets/home/intermediate_button.png',
                    width: MediaQuery.of(context).size.width * 0.8),
                Image.asset('assets/home/advanced_button.png',
                    width: MediaQuery.of(context).size.width * 0.8)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
