import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  //var works = await _recorder.isEncoderSupported(Codec.pcm16AIFF);
  
  bool _isRecording = false;
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    //await _recorder.openAudioSession();
    await _recorder.openRecorder();
    
  }

  Future<void> _startRecording() async {
    _filePath = 'test_register.wav';
    await _recorder.startRecorder(
      toFile: _filePath,
      //codec: Codec.pcm16AIFF,
      bitRate: 16000,
    );
    setState(() {
      _isRecording = true;
    });
    await Future.delayed(Duration(seconds: 4));
    await _stopRecording();
    print("Check here");
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    //_recorder.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isRecording
                ? Text(
                    'Recording...',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )
                : Text(
                    'Please speak clearly into the mic in your normal voice, repeating the line:\n \" My Name is {Your First Name}\"\nPress the button to begin recording',
                    style: TextStyle(fontSize: 20),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRecording ? null : _startRecording,
              child: Text('Record'),
            ),
          ],
        ),
      ),
    );
  }
}