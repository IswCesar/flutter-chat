import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat/global/colors.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ChatMessage extends StatefulWidget {
  final String text;
  final String uid;
  final int type;
  final AnimationController animationController;

  const ChatMessage(
      {Key key,
      @required this.text,
      @required this.uid,
      @required this.animationController,
      this.type})
      : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool _isPlaying = false;
  int _totalDuration;
  int _currentDuration;
  double _completedPercentage = 0.0;

  @override
  Widget build(BuildContext context) {
    final colors = new ColorApp();
    final authService = Provider.of<Auth>(context, listen: false);

    return FadeTransition(
      opacity: widget.animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: widget.animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: this.widget.uid == authService.user.uid
              ? _myMessage(colors)
              : _notMyMessage(colors),
        ),
      ),
    );
  }

  _myMessage(colors) {
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
            myMessageType(this.widget.type, colors),
          ],
        ),
      ),
    );
  }

  myMessageType(type, colors) {

    switch (type) {
      case 1:
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          trailing: CircleAvatar(
            radius: 24.0,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
          title: Text(
            this.widget.uid,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: colors.buttonBG,
              fontFamily: "Geometric-212-BkCn-BT",
            ),
          ),
          subtitle: Text(
            this.widget.text,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16.0,
              color: colors.messageOut,
              fontFamily: "Geometric-212-BkCn-BT",
            ),
          ),
        );
        break;
      case 2:
        return Image.memory(dataFromBase64String(this.widget.text));
        break;
      case 3:
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                value: _completedPercentage,
              ),
              IconButton(
                icon: _isPlaying
                    ? Icon(Icons.play_disabled)
                    : Icon(Icons.play_arrow),
                onPressed: () => _onPlay(filePath: this.widget.text),
              ),
            ],
          ),
        );
        break;
      case 4:
        final url = "${Environment.uploadUrl}/${this.widget.text}";
        // print(uri);
        print("Enter to 4");
        return VideoPlayerScreen(url: url);
        break;
    }
  }

  Future<void> _onPlay({@required String filePath}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying && _completedPercentage == 0.0) {
      String uri = '${Environment.audioUrl}/${filePath}';
      print(uri);
      audioPlayer.play(uri, isLocal: false);
      setState(() {
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });

      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  outMessageType(type, colors) {
    print(type);
    switch (type) {
      case 1:
        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          leading: CircleAvatar(
            radius: 24.0,
            backgroundImage: AssetImage('assets/logo.png'),
          ),
          title: Text(
            this.widget.uid,
            style: TextStyle(
              color: colors.homeBG,
              fontFamily: "Geometric-212-BkCn-BT",
            ),
          ),
          subtitle: Text(
            this.widget.text,
            style: TextStyle(
              fontSize: 16.0,
              color: colors.messageOut,
              fontFamily: "Geometric-212-BkCn-BT",
            ),
          ),
        );
        break;
      case 2:
        return Image.memory(dataFromBase64String(this.widget.text));
      case 3:
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                value: _completedPercentage,
              ),
              IconButton(
                icon: _isPlaying
                    ? Icon(Icons.play_disabled)
                    : Icon(Icons.play_arrow),
                onPressed: () => _onPlay(filePath: this.widget.text),
              ),
            ],
          ),
        );
    }
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
          children: [outMessageType(this.widget.type, colors)],
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
