import 'dart:convert';
import 'dart:typed_data';

import 'package:chat/global/colors.dart';
import 'package:chat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {Key key,
      @required this.text,
      @required this.uid,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = new ColorApp();
    final authService = Provider.of<Auth>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: this.uid == authService.user.uid
              ? _myMessage(colors)
              : _notMyMessage(colors),
        ),
      ),
    );
  }

  Widget _myMessage(colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: colors.homeBG,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(30, 0, 10, 15),
        child: Column(
          children: [
            dataFromBase64String(this.text) is Uint8List
                ? Image.memory(dataFromBase64String(this.text))
                : ListTile(
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    trailing: CircleAvatar(
                      radius: 24.0,
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                    title: Text(
                      this.uid,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: colors.buttonBG,
                        fontFamily: "Geometric-212-BkCn-BT",
                      ),
                    ),
                    subtitle: Text(
                      this.text,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: colors.messageOut,
                        fontFamily: "Geometric-212-BkCn-BT",
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _notMyMessage(colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: colors.buttonBG,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 0, 30, 15),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              leading: CircleAvatar(
                radius: 24.0,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
              title: Text(
                this.uid,
                style: TextStyle(
                  color: colors.homeBG,
                ),
              ),
              subtitle: Text(
                this.text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: colors.messageOut,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  dataFromBase64String(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      return '';
    }
  }
}
