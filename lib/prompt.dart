import 'dart:async';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mindinsync/BottomNavigation.dart';
import 'package:mindinsync/KnowledgeService.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});
  @override
  State<StatefulWidget> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final RecorderStream _recorder = RecorderStream();
  var knowledge;
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  List<String> transcriptArray = [];
  var tran_store;
  var openai_key;
  late FlutterTts tts;
  bool isPlaying = false;
  var _controller = TextEditingController();
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];
  String promptStart =
      "You are an assistant for user suffering from Short Term Memory Loss, please do your best to answer their questions in 1 to 2 sentences based on all your knowledge in addition to the following knowledge data: {";

  @override
  void initState() {
    super.initState();
    knowledge = KnowledgeService();
    _recorder.initialize();
    loadKey();
    loadKnowledge();

    messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            promptStart,
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      ),
    ];

    tts = FlutterTts();
    tts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    tts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  void loadKnowledge() {
    var facts = knowledge.getKnowledge(1);
    facts.then((value) {
      promptStart += knowledge.knowledgeLoaded + "}";
      //print (promptStart);
      messages = [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              promptStart,
            ),
          ],
          role: OpenAIChatMessageRole.assistant,
        ),
      ];
    });
  }

  void toggleTTS(String text) async {
    if (isPlaying) {
      await tts.stop();
    } else {
      await tts.speak(text);
    }
  }

  void loadKey() async {
    await dotenv.load(fileName: ".env");
    const openai_var = "OPEN_AI_API_KEY";
    openai_key = dotenv.env[openai_var];
    OpenAI.apiKey = openai_key!;
  }

  void streamingRecognize() async {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Transcription Overflow"),
      content: Text(
          "Your Transcription has hit the 5 minute limit and stopped recording, please start a new transcription"),
      actions: [
        okButton,
      ],
    );

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((event) {
      _audioStream!.add(event);
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

    responseStream.listen((data) {
      try {
        final currentText =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');

        if (data.results.first.isFinal) {
          transcriptArray.add(currentText);
          setState(() {
            stopRecording();
            promptLLM(currentText);
            //started = true;
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
      });
    });
  }

  void stopRecording() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {});
  }

  void promptLLM(String question) async {
    //recognizing = true;
    messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            question,
          ),
        ],
        role: OpenAIChatMessageRole.user,
      ),
    );

    OpenAIChatCompletionModel results = await OpenAI.instance.chat
        .create(model: "gpt-3.5-turbo", messages: messages, maxTokens: 60);
    final mindResponse = results.choices[0].message.content!.first.text;
    messages.add(
      OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            mindResponse!,
          ),
        ],
        role: OpenAIChatMessageRole.assistant,
      ),
    );
    transcriptArray.add("MindAI: " + mindResponse!);
    setState(() {     
      //recognizing = false;
      _controller.clear();
      //_controller.clearComposing();
    });
  }

  RecognitionConfigBeta _getConfig() => RecognitionConfigBeta(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'en-US',
        profanityFilter: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask MindAI a question!'),
        backgroundColor: Colors.blue[300],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          ElevatedButton(
            onPressed: recognizing ? stopRecording : streamingRecognize,
            child: recognizing
                ? const Text('Listening')
                : const Text('Ask a question with your voice'),
          ),
          TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.question_answer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Or type out your question for MindAI',
              ),
              onSubmitted: (String value) {
                // Navigator.push(context, PromptScreen());
                  recognizeFinished = true;
                  transcriptArray.add(value);
                  setState(() {});
                promptLLM(value);
              }),
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
                    return new GestureDetector(
                        onTap: () {
                          toggleTTS(
                              transcriptArray[Index].replaceAll("MindAI:", ""));
                        },
                        child: new Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          //color: Colors.amber[600],
                          decoration: BoxDecoration(
                            color: (Index % 2 == 1)
                                ? Colors.grey[300]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(transcriptArray[Index]),
                        ));
                  }),
            )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index for the Home screen
        onTap: (index) {
          switch (index) {
            case 0:
              stopRecording();
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              stopRecording();
              Navigator.pushNamed(context, '/Search');
              break;
            case 2:
              stopRecording();
              Navigator.pushNamed(context, '/knowledge_base');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
