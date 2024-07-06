import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/generated/google/cloud/speech/v1p1beta1/cloud_speech.pb.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mindinsync/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const RecordingScreen());
}
List<String> speakers = ["\nSpeaker 1: ", "\nSpeaker 2: ", "\nSpeaker 3: ", "\nSpeaker 4: ", "\nSpeaker 5: ", "\nSpeaker 6: "];
 

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AudioRecognize(),
    );
  }
}

class AudioRecognize extends StatefulWidget {
  const AudioRecognize({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AudioRecognizeState();
}

class _AudioRecognizeState extends State<AudioRecognize> {
  final RecorderStream _recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;

  @override
  void initState() {
    super.initState();

    _recorder.initialize();
  }

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
    });

    await _recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString('${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToTextBeta.viaServiceAccount(serviceAccount);
    final config = _getConfig();
  
    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfigBeta(config: config, interimResults: true),
        _audioStream!);


    responseStream.listen((data) {
      final words = data.results.first.alternatives.first.words;
      String transcript = speakers[0];
      int currentSpeaker = 1;
      for(int i = 0; i < words.length; i++){
        if(currentSpeaker != words[i].speakerTag){
          currentSpeaker = words[i].speakerTag;
          transcript += speakers[currentSpeaker-1];
        }
        transcript += words[i].word + " ";
      }
      if(words.length > 0){
      setState(() {
          text = transcript;
        });
      }
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');
      if (data.results.first.isFinal) {
        setState(() {
          recognizeFinished = true;
        });
      } else {
        setState(() {
          recognizeFinished = true;
        });
      }
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    final directory = await getApplicationDocumentsDirectory();
    var dt = DateTime.now();
    final file = File(directory.path + '/transcription'+ dt.year.toString() + dt.month.toString() + dt.day.toString() + dt.hour.toString() 
    + dt.minute.toString() + dt.second.toString() + '.txt');
    file.writeAsString(text);
    setState(() {
      recognizing = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(title: 'MindInSync',)),);
  }



  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US',
      diarizationConfig: SpeakerDiarizationConfig(enableSpeakerDiarization: true, minSpeakerCount: 1, maxSpeakerCount: 6)
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording Audio'),
      ),
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        reverse: true, 
        child: Center( child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (recognizeFinished)
              _RecognizeContent(
                text: text,
              ),                        
              ElevatedButton(               
              onPressed: recognizing ? stopRecording : streamingRecognize,
              child: recognizing
                  ? const Text('Finish Recording')
                  : const Text('Begin Recording Your Conversation'),
            ),
          ],
        ),
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _RecognizeContent extends StatelessWidget {
  final String? text;

  const _RecognizeContent({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Transcribed Conversation:',
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            text ?? '---',
          ),
        ],
      ),
    );
  }
}