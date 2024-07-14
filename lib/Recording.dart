import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/generated/google/cloud/speech/v1p1beta1/cloud_speech.pb.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mindinsync/StorageService.dart';
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
  var tran_store;
  ScrollController _scrollController = new ScrollController();
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
    tran_store = StorageService();
    _recorder.initialize();

    //streamingRecognize();
  }

  void streamingRecognize() async {
    _copyFileFromAssets('register.wav');

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop();},
    );

    AlertDialog alert = AlertDialog(
      title: Text("Transcription Overflow"),
      content: Text("Your Transcription has hit the 5 minute limit and stopped recording, please start a new transcription"),
      actions: [
        okButton,
      ],
    );

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
      try {
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
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
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

    setState(() {});
  }

  void saveAndExit() async {
    final directory = await getApplicationDocumentsDirectory();
    var dt = DateTime.now();
    var file_name = 'transcription' +
        dt.year.toString() +
        dt.month.toString() +
        dt.day.toString() +
        dt.hour.toString() +
        dt.minute.toString() +
        dt.second.toString() +
        '.txt';
    final file = File(directory.path + '/' + file_name);
    file.writeAsString(transcriptArray.toString());
    tran_store.insertTranscriptFile(file_name, transcriptArray.toString());
    /*var scripts = await tran_store.getTranscripts();
    for(int i = 0; i < scripts.length; i++){
    print(scripts[i]['transcript_content']);
    }*/
  }

  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US',
      profanityFilter: true,
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
                ? const Text('Finish Recording(5 Minute Maximum)')
                : const Text('Begin Recording Your Conversation'),
          ),
          if (recognizeFinished)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: new ListView.builder(
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: transcriptArray.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return new Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      //color: Colors.amber[600],
                      decoration: BoxDecoration(
                        color: speakercolor[speakerArray[Index] - 1],
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
