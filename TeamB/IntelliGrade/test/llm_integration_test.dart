import 'dart:io';
import 'package:dotenv/dotenv.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intelligrade/api/llm/llm_api.dart';
import 'package:intelligrade/api/llm/prompt_engine.dart';
import 'package:intelligrade/api/moodle/moodle_api_singleton.dart';
import 'package:intelligrade/controller/model/beans.dart';
import 'package:intelligrade/controller/model/xml_converter.dart';

Future main() async {
  // set to true to test full integration (costs money for LLM)
  bool fullTest = true;

  // load env
  // await dotenv.load(fileName: 'assets/.env');
  // print('PERPLEXITY_API_KEY=${dotenv.env['PERPLEXITY_API_KEY']}');

  final env = DotEnv(includePlatformEnvironment: true)..load();
  final apiKey = /* env['OPENAI_API_KEY']; */ env['PERPLEXITY_API_KEY'];
  print('PERPLEXITY_API_KEY=$apiKey');

  // test LLM connection
  if (!fullTest) {
    const llmMsg = 'How many stars are there in our galaxy?'; // no-charge query
    print('LLM Post: $llmMsg');
    final llm = LlmApi(/* dotenv.env['PERPLEXITY_API_KEY'] */ apiKey!);
    final String llmResp = await llm.postToLlm(llmMsg);
    print('LLM Resp: $llmResp');
  }

  // test fully integrated path !!! warning: costs money!
  else {
    // String prompt = PromptEngine.generatePrompt(AssignmentForm(
    //     questionType: QuestionType.multichoice,
    //     subject: 'Computer Science',
    //     topic: 'Java',
    //     gradeLevel: 'Freshman',
    //     title: 'Title',
    //     questionCount: 3,
    //     maximumGrade: 50));

    String prompt = PromptEngine.generatePrompt(AssignmentForm(
        questionType: QuestionType.coding,
        subject: 'Data Types',
        topic:
            'writing a java application that adds different types of numbers',
        gradeLevel: 'Freshman',
        title: 'Title',
        questionCount: 3,
        maximumGrade: 50,
        assignmentCount: 2,
        gradingCriteria: "various aspects of number types",
        codingLanguage: "Java"));

    print('Generated prompt: $prompt');
    final llm = LlmApi(/* dotenv.env['PERPLEXITY_API_KEY'] */ apiKey!);
    final String llmResp = await llm.postToLlm(prompt);
    List<String> parsedResp = llm.parseQueryResponse(llmResp);
    String xmlStr;
    try {
      xmlStr = parsedResp[0].replaceAll(RegExp(r"\\n"), "");
    } catch (e) {
      print('Unable to parse out XML string: $e');
      exit(1);
    }
    print('parsedXml: $xmlStr');

    print('\nConvert to Object...\n');
    Quiz quiz = Quiz.fromXmlString(xmlStr);
    print(quiz);

    var moodleApi = MoodleApiSingleton();
    print('Login Test');
    print('--------------------');
    try {
      await moodleApi.login('tzhu', 'Good4TeamB!');
      print('Login successful!');
    } catch (e) {
      print(e);
    }

    print('\nImport quiz test');
    print('--------------------');
    try {
      String courseId = '2';
      String reconvertedXml = XmlConverter.convertQuizToXml(quiz).toXmlString();
      print('Reconverted XML: $reconvertedXml');
      await moodleApi.importQuiz(courseId, reconvertedXml);
      print('Questions successfully imported!');
    } catch (e) {
      print(e);
    }
  }
}
