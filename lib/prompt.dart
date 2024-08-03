import 'dart:async';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mindinsync/BottomNavigation.dart';
import 'package:mindinsync/Drawer.dart';
import 'package:mindinsync/KnowledgeService.dart';
import 'package:mindinsync/StorageService.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sound_stream/sound_stream.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});
  @override
  State<StatefulWidget> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  var knowledge;
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>>? _audioStreamSubscription;
  BehaviorSubject<List<int>>? _audioStream;
  StreamController<Food>? _recordingDataController;
  StreamSubscription? _recordingDataSubscription;
  List<String> transcriptArray = [];
  var tran_store;
  var openai_key;
  var isLoaded = false;
  late FlutterTts tts;
  bool isPlaying = false;
  var _controller = TextEditingController();
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];
  String promptStart =
      "You are a caregiver for a user suffering from Short Term Memory Loss, please do your best to answer their questions in 1 to 2 sentences based on all your knowledge in addition to the following knowledge data: {";

  @override
  void initState() {
    super.initState();
    knowledge = KnowledgeService();
    tran_store = StorageService();
    Permission.microphone.request();
    //_recorder.initialize();
    loadKey();
    //knowledge.queryInventory("SELECT Price, Quantity, Location, ProductName FROM Product WHERE LOWER(ProductName) LIKE '%ssd%';");
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

  void loadKnowledge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString("user_id");

    print(userid);
    var facts = knowledge.getKnowledge(int.parse(userid!));
    facts.then((value) {
      var inventory = knowledge.getInventory();
      inventory.then((inventory) {
        var transcripts = tran_store.getLatestTranscript();
        transcripts.then((transcripts) {
          var past_transcripts = "";
          for (var i = 0; i < transcripts.length; i++) {
            past_transcripts += (transcripts[i]).toString() + "\n";
          }
          //print(past_transcripts);
          promptStart += knowledge.knowledgeLoaded + "}";
          promptStart +=
              " and the following inventory data {" + inventory + "}";
          promptStart +=
              " and the following transcribed conversations recorded by the user " +
                  past_transcripts;
          // print(promptStart);
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
      });
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

    await _recorder.openAudioSession();
    // Stream to be consumed by speech recognizer
    _audioStream = BehaviorSubject<List<int>>();

    _recordingDataController = StreamController<Food>();
    // _audioStream = BehaviorSubject<List<int>>();
    _recordingDataSubscription =
        _recordingDataController?.stream.listen((buffer) {
      if (buffer is FoodData) {
        _audioStream!.add(buffer.data!);
      }
    });
    await _recorder.startRecorder(
        toStream: _recordingDataController!.sink,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 16000);

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
    await _recorder.stopRecorder();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    await _recordingDataSubscription?.cancel();
    setState(() {});
  }

  void promptLLM(String question) async {
    if (question.toLowerCase().contains("inventory") ||
        question.toLowerCase().contains("in stock")) {
      print("Recognized");
      var inventoryMessage = [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Can you write just a sql statement that searches a Product table in a MariaDB database, returning the Price, Quantity, Location, and ProductName. Please search within the ProductName making sure to use % in the search string, searching with everything converted to lower case and only searching for singular nouns. The statement to search from is {" +
                  question +
                  "}. Please return only the SQL statement.",
            ),
          ],
          role: OpenAIChatMessageRole.assistant,
        ),
      ];
      OpenAIChatCompletionModel results = await OpenAI.instance.chat.create(
          model: "gpt-4o-mini", messages: inventoryMessage, maxTokens: 150);
      var inventory = results.choices[0].message.content!.first.text;
      inventory = inventory!
          .replaceAll("`", "")
          .replaceAll("sql", "")
          .replaceAll("\n", " ");
      print(inventory);
      var queryresults = knowledge.queryInventory(inventory);
      print(queryresults);
      queryresults.then((value) async{
        inventoryMessage = [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are an AI assistant for people suffering from STML, please answer the following question to the best of your ability within 1 to 2 sentences based on the following inventory {" +
                  value +
                  "}",
            ),
          ],
          role: OpenAIChatMessageRole.assistant,
        ),
      ];
      results = await OpenAI.instance.chat.create(
          model: "gpt-4o-mini", messages: inventoryMessage, maxTokens: 150);
      var response = results.choices[0].message.content!.first.text;
      print(response);
      transcriptArray.add("MindAI: " + response!);
       messages.add(
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              response!,
            ),
          ],
          role: OpenAIChatMessageRole.assistant,
        ),
      );
      setState(() {
      //recognizing = false;
      _controller.clear();
      //_controller.clearComposing();
    });
      });
      
      
    } else {
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
          .create(model: "gpt-4o-mini", messages: messages, maxTokens: 150);
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
    }
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

  void setTranscription() {
    if (!isLoaded) {
      var args = ModalRoute.of(context)!.settings.arguments as String?;
      if (args!.length > 0) {
        if (args! == "supersecretaudiostartnobodygoingtofigureout") {
          streamingRecognize();
          setState(() {});
        } else {
          Future.delayed(const Duration(seconds: 2)).then((val) {
            recognizeFinished = true;
            transcriptArray.add(args);
            setState(() {});
            promptLLM(args);
          });
        }
      }
      isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setTranscription();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ask MindAI a question!'),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                if (recognizeFinished)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: false,
                      itemCount: transcriptArray.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GestureDetector(
                          onTap: () {
                            toggleTTS(transcriptArray[Index]
                                .replaceAll("MindAI:", ""));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (Index % 2 == 1)
                                  ? Colors.grey[300]
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(transcriptArray[Index]),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        side: const BorderSide(
                            width: 2, // the thickness
                            color: Colors.grey // the color of the border
                            )),
                    onPressed: recognizing ? stopRecording : streamingRecognize,
                    child: recognizing
                        ? const Text('Listening')
                        : const Text('Ask a question with your voice'),
                  ),
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
                      recognizeFinished = true;
                      transcriptArray.add(value);
                      setState(() {});
                      promptLLM(value);
                    }),
                const Text(
                    'MindAI may sometimes provide innacurate information, please exercise caution'),
              ],
            ),
          ),
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
              Navigator.pushNamed(context, '/document_upload');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
