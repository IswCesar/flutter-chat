import 'package:chat/global/colors.dart';
import 'package:chat/services/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/services/auth.dart';
import 'package:chat/services/socket.dart';
import 'package:chat/services/users.dart';

import 'package:chat/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final userService = UserService();
  final colors = ColorApp();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final socket = Provider.of<Socket>(context);
    final user = auth.user;

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
      backgroundColor: colors.labelAccountColor,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        child: _ListViewUsers(),
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check_circle,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
      ),
    );
  }

  ListView _ListViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(
        user.name,
        style: TextStyle(
          color: colors.title,
          fontFamily: "Geometric-415-Black-BT",
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(user.email,
          style: TextStyle(
            color: colors.title,
            fontFamily: "Geometric-212-BkCn-BT",
            fontSize: 16.0,
          )),
      leading: CircleAvatar(
        child: Text(
          user.name.substring(0, 2),
        ),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        print(user.name);
        print(user.email);
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _loadUsers() async {
    this.users = await userService.getUsers();
    setState(() {});
    // if failed use refreshFalid()
    _refreshController.refreshCompleted();
  }
}
