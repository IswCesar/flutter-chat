import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

import 'package:chat/utils/enums.dart';
import 'package:chat/global/colors.dart';
import 'package:path_provider/path_provider.dart';

class RecorderAudio extends StatefulWidget {
  final Function onSaved;

  const RecorderAudio({Key key, @required this.onSaved}) : super(key: key);

  @override
  _RecorderAudioState createState() => _RecorderAudioState();
}

class _RecorderAudioState extends State<RecorderAudio> {
  final colors = ColorApp();
  IconData _recordIcon = Icons.mic_none_outlined;
  RecordingState _recordingState = RecordingState.UnSet;
  // Recorder properties
  FlutterAudioRecorder _audioRecorder;
  final _snackbar =
      SnackBar(content: Text('Please allow recording from setttings.'));

  @override
  void initState() {
    super.initState();
    FlutterAudioRecorder.hasPermissions.then((hasPermission) {
      if (hasPermission) {
        _recordingState = RecordingState.Set;
        _recordIcon = Icons.mic_outlined;
      }
    });
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    _audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      child: GestureDetector(
        onTap: () async {
          await _onRecordButtonPressed();
          setState(() {});
        },
        child: IconTheme(
          data: IconThemeData(color: colors.labelAccountColor),
          child: Icon(_recordIcon),
        ),
      ),
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.mic_rounded;
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(_snackbar);
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().microsecondsSinceEpoch.toString() +
        '.aac';
  
    _audioRecorder = FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
    await _audioRecorder.initialized;
  }

  _startRecording() async {
    await _audioRecorder.start();
  }

  _stopRecording() async {
    await _audioRecorder.stop();
    // Here we call the father function
    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initRecorder();
      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(_snackbar);
    }
  }
}
