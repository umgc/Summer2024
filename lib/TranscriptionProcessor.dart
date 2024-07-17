import 'dart:convert';

import 'package:mindinsync/StorageService.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class TranscriptionProcessor {
  static final TranscriptionProcessor _instance = TranscriptionProcessor._internal();
  static final StorageService tran_store = new StorageService();

  factory TranscriptionProcessor() {
    return _instance;
  }
  final String promptStart = "You are a tool for processing a captured transcription. The transcription is enclosed within the following brackets."; 
  final String promptEnd = ". Please return only a JSON array of keys [\"keywords\", \"summary\", \"title\", \"transcript\"] with transcript and keywords being arrays, and no text outside the JSON array, containing the following 4 values derived from this transcription: 1. A list of 5 relevant keywords extracted from the transcription other than speaker, 2: A brief 2-3 sentence summary of the transcription, 3: A title for the transcription based on the content, 4: A copy of the transcription text autocorrected to remove any obvious errors that occurred during transcription";

  TranscriptionProcessor._internal();



Future<String> processTranscription(String Transcription, String name) async {
  await dotenv.load(fileName: ".env");
  const openai_var = "OPEN_AI_API_KEY";
  var openai_key = dotenv.env[openai_var];
  //print(openai_key);
  String prompt = promptStart + Transcription.toString() + promptEnd;
  OpenAI.apiKey = openai_key!;

  final systemMessage = OpenAIChatCompletionChoiceMessageModel(
  content: [
    OpenAIChatCompletionChoiceMessageContentItemModel.text(
      prompt,
    ),
  ],
  role: OpenAIChatMessageRole.assistant,
);

  final requestMessages = [
  systemMessage,
];

  OpenAIChatCompletionModel results = await OpenAI.instance.chat.create(model: "gpt-3.5-turbo", messages: requestMessages,  responseFormat: {"type": "json_object"},);
  final jsonresults = results.choices.first.message.content?.first.text;
  print(jsonresults);
  var decoded = json.decode(jsonresults!);
  //await tran_store.updateTranscriptFile(decoded["title"], decoded["transcript"].toString(), decoded["keywords"].toString(), decoded["summary"], name);
   await tran_store.updateTranscriptFile(decoded["title"].replaceAll('\'', '\'\''), decoded["transcript"].toString().replaceAll('\'', '\'\''), decoded["keywords"].toString().replaceAll('\'', '\'\'').replaceAll("\"","").replaceAll("[","").replaceAll("]",""), decoded["summary"].replaceAll('\'', '\'\''), name);
  return "";
}

 

  


 
}