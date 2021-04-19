import 'dart:convert';
import 'dart:io';

import 'package:chat/global/colors.dart';
import 'package:chat/models/message_response.dart';
import 'package:chat/widgets/recorder_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:chat/widgets/chat_message.dart';

import 'package:chat/services/chat.dart';
import 'package:chat/services/socket.dart';
import 'package:chat/services/auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  Directory appDirectory;
  ChatService chatService;
  Socket socketService;
  Auth authService;
  bool _isWriting = false;
  List<ChatMessage> _messages = [];

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final colors = ColorApp();

  /// For manage image
  File _image;
  File _video;
  final picker = ImagePicker();

  // For store audios
  List<String> records;

  @override
  void initState() {
    super.initState();
    records = [];
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<Socket>(context, listen: false);
    this.authService = Provider.of<Auth>(context, listen: false);
    this.socketService.socket.on('personal-msg', _listenMsg);
    _loadHistory(this.chatService.userTo.uid);
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      setState(() {
        print('Directory:');
        print(appDirectory);
      });
    });
  }

  ///
  /// Camera methods start
  ///
  _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = File(pickedFile.path);
      _prepareFile();
    });
  }
  
  _videoFromCamera() async {
    final pickedFile =
        await picker.getVideo(source: ImageSource.camera);
      _video = File(pickedFile.path);
      final video = await this.chatService.uploadFile(_video.path, 'video');
      print(video);
      print('_videoFromCamera called...');
      _uploadFile(video.filename, 4);
  }

  _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(pickedFile.path);
      _prepareFile();
    });
  }

  _prepareFile() {
    final base64Image = base64Encode(_image.readAsBytesSync());
    final filename = _image.path.split('/').last;
    _uploadImage(base64Image, filename);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: colors.loginBG,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(
                        'Take photo',
                        style: TextStyle(
                          color: colors.title,
                          fontFamily: "Geometric-212-BkCn-BT",
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                      'Take video',
                      style: TextStyle(
                        color: colors.title,
                        fontFamily: "Geometric-212-BkCn-BT",
                      ),
                    ),
                    onTap: () {
                      _videoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  ///
  /// Camera methods ends
  ///

  void _loadHistory(String uid) async {
    List<Msg> chat = await this.chatService.getChat(uid);
    print(chat);
    final history = chat.map((e) => ChatMessage(
          text: e.msg,
          uid: e.from,
          type: e.type,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    if (!this.mounted) return;

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMsg(dynamic payload) {
    print('I have data');
    ChatMessage message = ChatMessage(
      text: payload['msg'],
      uid: payload['from'],
      type: payload['type'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
      message.animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;
    final socket = Provider.of<Socket>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.inputColor,
        elevation: 1,
        // centerTitle: true,
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
                    userTo.name,
                    style: TextStyle(
                      fontFamily: "Geometric-212-BkCn-BT",
                      color: colors.title,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputchat(),
            ),
          ],
        ),
      ),
    );
  }

  _inputchat() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: colors.inputColor),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().length > 0) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send Message',
                  hintStyle: TextStyle(
                    color: colors.title,
                  ),
                ),
                style: TextStyle(
                  color: colors.title,
                ),
                focusNode: _focusNode,
              ),
            ),
            RecorderAudio(onSaved: _onRecordComplete),
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: IconTheme(
                  data: IconThemeData(color: colors.labelAccountColor),
                  child: Icon(Icons.camera_alt_rounded),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 0.0),
              child: GestureDetector(
                onTap: () {
                  _imgFromGallery();
                },
                child: IconTheme(
                  data: IconThemeData(color: colors.labelAccountColor),
                  child: Icon(Icons.image),
                ),
              ),
            ),
            Container(
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _isWriting
                          ? () =>
                              _handleSubmit(_textEditingController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.only(right: 0.0),
                      child: IconTheme(
                        data: IconThemeData(
                          color: colors.title,
                        ),
                        child: IconButton(
                          highlightColor: colors.loginBG,
                          splashColor: colors.loginBG,
                          icon: Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _handleSubmit(
                                  _textEditingController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  // Audio starts

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.endsWith(".aac")) {
        records.add(onData.path);
      }
    }).onDone(() async {
      records.sort();
      records = records.reversed.toList();
      final audio = await this.chatService.uploadAudio(records[0], 'audio1');
      await _uploadAudio(audio.filename);
    });
  }

  // Audio ends

  // Uploads to server start

  _uploadFile(String text, int type) {
    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      type: type,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    this.socketService.emit('personal-msg', {
      'from': authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': text,
      'type': type
    });
  }

  _uploadAudio(String audioPath) {

    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: audioPath,
      type: 3,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    this.socketService.emit('personal-msg', {
      'from': authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': audioPath,
      'type': 3
    });
  }
  

  _uploadImage(String image, String filename) {
    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: image,
      type: 2,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    this.socketService.emit('personal-msg', {
      'from': authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': image,
      'filename': filename,
      'type': '2'
    });
  }
  
  _handleSubmit(String text) {
    if (text.length == 0) return;

    _focusNode.requestFocus();
    _textEditingController.clear();

    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      type: 1,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    this.socketService.emit('personal-msg', {
      'from': authService.user.uid,
      'to': this.chatService.userTo.uid,
      'msg': text,
      'type': 1
    });
  }

  // Uploads to server end

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-msg');
    super.dispose();
  }
}
