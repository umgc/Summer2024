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

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});
  @override
  State<StatefulWidget> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final RecorderStream _recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  List<String> transcriptArray = [];
  List<int> speakerArray = [];

  List<String> speakers = [
    "'Username': ",
    "Speaker 2: ",
    "Speaker 3: ",
    "Speaker 4: ",
    "Speaker 5: ",
    "Speaker 6: "
  ];
  final List<Color?> speakercolor = [
    Colors.green[100],
    Colors.indigo[100],
    Colors.amber[100],
    Colors.red[100],
    Colors.blueGrey[100],
    Colors.purple[100]
  ];
  var speakerCount = 0;

  @override
  void initState() {
    super.initState();

    _recorder.initialize();

    //streamingRecognize();
  }

  void streamingRecognize() async {
    _copyFileFromAssets('register.wav');

    var stream = _getAudioStream('register.wav');
    var data = await rootBundle.load('assets/register.wav');
    var started = false;

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      if (started == false) {
        _audioStream!.add(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        started = true;
      } else {
        _audioStream!.add(event);
      }
    });
    await _recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToTextBeta.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfigBeta(config: config, interimResults: true),
        _audioStream!);

    var firstsentence = true;

    responseStream.listen((data) {
      final words = data.results.first.alternatives.first.words;
      String transcript = "";
      transcriptArray = [];
      speakerArray = [];
      int currentSpeaker = 0;
      for (int i = 0; i < words.length; i++) {
        if (firstsentence) {
          if (words[i].word.contains('.')) {
            firstsentence = false;
          }
        } else {
          if (currentSpeaker != words[i].speakerTag) {
            if (currentSpeaker != 0) {
              transcriptArray.add(transcript);
              speakerArray.add(currentSpeaker);
            }
            currentSpeaker = words[i].speakerTag;
            transcript = speakers[currentSpeaker - 1];
          }
          transcript += words[i].word + " ";
        }
      }
      if (transcript.length > 0) {
        transcriptArray.add(transcript);
        speakerArray.add(currentSpeaker);
      }
      firstsentence = true;
      if (data.results.first.isFinal) {
        setState(() {
          started = true;
          recognizeFinished = true;
        });
      } else {
        recognizeFinished = false;
        /*setState(() {
          recognizeFinished = false;
        });*/
      }
    }, onDone: () {
      setState(() {
        recognizing = false;
        saveAndExit();
      });
    });
  }

  Future<Stream<List<int>>> _getAudioStream(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    return File(path).openRead();
  }

  Future<void> _copyFileFromAssets(String name) async {
    var data = await rootBundle.load('assets/$name');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();

    setState(() {
      //recognizing = false;
    });
  }

  void saveAndExit() async {
    final directory = await getApplicationDocumentsDirectory();
    var dt = DateTime.now();
    final file = File(directory.path +
        '/transcription' +
        dt.year.toString() +
        dt.month.toString() +
        dt.day.toString() +
        dt.hour.toString() +
        dt.minute.toString() +
        dt.second.toString() +
        '.txt');
    file.writeAsString(text);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(title: 'MindInSync',)),);
  }

  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US',
      diarizationConfig: SpeakerDiarizationConfig(
          enableSpeakerDiarization: true,
          minSpeakerCount: 1,
          maxSpeakerCount: 6));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recording"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ElevatedButton(
            onPressed: recognizing ? stopRecording : streamingRecognize,
            child: recognizing
                ? const Text('Finish Recording')
                : const Text('Begin Recording Your Conversation'),
          ),
          if (recognizeFinished)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  
                  itemCount: transcriptArray.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return new Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                      //color: Colors.amber[600],
                      decoration: BoxDecoration(
                        
                        color: speakercolor[speakerArray[Index]-1],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(transcriptArray[Index]),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
/*

class _RecognizeContent extends StatelessWidget {
  final String? text;


  const _RecognizeContent({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ListView.builder
              (
                itemCount: transcriptArray.length()
                itemBuilder: (BuildContext ctxt, int Index) {
                  return new Text((text?.split(" "))![Index]);
                }
            )
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
*/