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
        title: Text(
          user.name,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {
            socket.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            Auth.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: (socket.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.blue[400])
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red[400],
                    ))
        ],
      ),
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
      title: Text(user.name),
      subtitle: Text(user.email),
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
