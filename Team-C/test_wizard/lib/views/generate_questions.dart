import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/course.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/models/question_generation_detail.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/services/llm_service.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class QuestionGenerateForm extends StatefulWidget {
  final String assessmentName;
  final int numberOfAssessments;
  final String topic;
  final String courseName;
  final int courseId;
  const QuestionGenerateForm({
    super.key,
    required this.assessmentName,
    required this.numberOfAssessments,
    required this.topic,
    required this.courseName,
    required this.courseId,
  });

  @override
  State<StatefulWidget> createState() => QuestionGenerateFormState();
}

class QuestionGenerateFormState extends State<QuestionGenerateForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final LLMService llmService = LLMService();
  final textEditingController = TextEditingController();

  final QuestionGenerationDetail questionGenerationDetail =
      QuestionGenerationDetail();

  bool isMathQuiz = false;
  int id = 0;

  @override
  void initState() {
    questionGenerationDetail.numberOfAssessments = widget.numberOfAssessments;
    questionGenerationDetail.topic = widget.topic;
    super.initState();
  }

  void setIsMathQuiz() {
    setState(() {
      //the value assigned here is not used in setting the state. Inverse is used. Dart Set methods require a param
      questionGenerationDetail.isMathQuiz = null;
      isMathQuiz = !isMathQuiz;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) {
        var state = AssessmentProvider();
        state.addQuestion(Question(
          points: 0,
          questionId: id++,
          questionText: '',
          questionType: 'shortAnswer',
        ));
        return state;
      },
      child: Scaffold(
        appBar: TWAppBar(
          context: context,
          screenTitle: 'Add Questions to ${widget.assessmentName}',
          implyLeading: true,
        ),
        body: ScrollContainer(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: screenSize.width * 0.9,
                    child: Consumer<AssessmentProvider>(
                      builder: (context, assessment, child) {
                        return Column(
                          children: <Widget>[
                            ...assessment.questions.map(
                              (question) {
                                return Column(children: [
                                  AddedQuestion(
                                    question: question,
                                    assessmentProvider: assessment,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ]);
                              },
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: 400,
                                child: CheckboxListTile(
                                    title: const Text(
                                        'Check if this assessment is about Math'),
                                    value: isMathQuiz,
                                    controlAffinity:
                                        ListTileControlAffinity.platform,
                                    onChanged: (value) {
                                      setIsMathQuiz();
                                    }),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                assessment.addQuestion(Question(
                                  questionId: id++,
                                  points: 0,
                                  questionText: '',
                                  questionType: 'multipleChoice',
                                ));
                              },
                              child: const Text('Add Question'),
                            ),
                            Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                return GenerateAssessmentsButton(
                                  formKey: _formKey,
                                  textEditingController: textEditingController,
                                  llmService: llmService,
                                  questionGenerationDetail:
                                      questionGenerationDetail,
                                  assessmentProvider: assessment,
                                  assessmentName: widget.assessmentName,
                                  courseName: widget.courseName,
                                  exampleAssessmentSetIndex: 0,
                                  exampleAssessmentIndex: 0,
                                  moodleUrl: userProvider.moodleUrl ?? '',
                                  token: userProvider.token ?? '',
                                  topic: widget.topic,
                                  courseId: widget.courseId,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddedQuestion extends StatelessWidget {
  final AssessmentProvider assessmentProvider;
  final Question question;
  final TextEditingController controller;

  AddedQuestion({
    super.key,
    required this.question,
    required this.assessmentProvider,
  }) : controller = TextEditingController.fromValue(
          TextEditingValue(
            text: question.questionText,
            selection: TextSelection.collapsed(
              offset: question.questionText.length,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 175,
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: question.questionType,
            items: const [
              DropdownMenuItem(
                value: 'multipleChoice',
                child: Text('Multiple Choice'),
              ),
              DropdownMenuItem(
                value: 'shortAnswer',
                child: Text('Short Answer'),
              ),
              DropdownMenuItem(
                value: 'essay',
                child: Text('Essay'),
              ),
            ],
            onChanged: (value) => assessmentProvider.updateQuestion(
                id: question.questionId, newType: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value) => assessmentProvider.updateQuestion(
                id: question.questionId, newText: value),
            decoration: const InputDecoration(
              hintText: 'What is 2 + 2?',
              border: OutlineInputBorder(),
            ),
            validator: Validators.checkIsEmpty,
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.amber),
          onPressed: () =>
              assessmentProvider.removeQuestion(question.questionId),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

class GenerateAssessmentsButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LLMService llmService;
  final TextEditingController textEditingController;
  final QuestionGenerationDetail questionGenerationDetail;
  final AssessmentProvider assessmentProvider;
  final String assessmentName;
  final String courseName;
  final int exampleAssessmentSetIndex;
  final int exampleAssessmentIndex;
  final String? moodleUrl;
  final String? token;
  final String topic;
  final int courseId;

  const GenerateAssessmentsButton(
      {super.key,
      required this.formKey,
      required this.textEditingController,
      required this.llmService,
      required this.questionGenerationDetail,
      required this.assessmentProvider,
      required this.assessmentName,
      required this.courseName,
      required this.exampleAssessmentSetIndex,
      required this.exampleAssessmentIndex,
      required this.moodleUrl,
      required this.token,
      required this.topic,
      required this.courseId});

  List<Assessment> getAssessmentFromOutput(List<dynamic> output, int id) {
    int questionId = 0; // same thing as assessmentId
    // generate a new assessment from the extracted
    List<Assessment> assessmentList = [];
    List<dynamic> multipleChoiceQuestions = [];
    List<dynamic> shortAnswerQuestions = [];
    List<dynamic> essayQuestions = [];
    Map<dynamic, dynamic> keyValueOutputEntry;

    //figure out position in object and how to get the list of questions in the question type.
    for (var parseAssessment in output) {
      dynamic assessment;
      if (assessment is Map<dynamic, dynamic>) {
        keyValueOutputEntry = assessment.cast<dynamic, dynamic>();
        assessment = keyValueOutputEntry.values;
      } else {
        assessment = parseAssessment;
      }
      multipleChoiceQuestions = assessment['multipleChoice'] ?? [];
      shortAnswerQuestions = assessment['shortAnswer'] ?? [];
      essayQuestions = assessment['essay'] ?? [];

      Assessment newAssessment = Assessment(id++, id, false);
      // increment assessmentId after using so that version isn't 0 indexed
      if (multipleChoiceQuestions.isNotEmpty) {
        for (var question in multipleChoiceQuestions) {
          newAssessment.questions.add(Question(
              points: 0,
              questionId: questionId++, // increment after use
              questionType: 'multipleChoice',
              questionText: question['QUESTION'] ?? question['question'] ?? '',
              answer:
                  (question['ANSWER'] ?? question['answer'] ?? '').toString(),
              answerOptions: List<String>.from(
                  question['OPTIONS'] ?? question['options'] ?? [])));
        }
      }
      if (shortAnswerQuestions.isNotEmpty) {
        for (var question in shortAnswerQuestions) {
          newAssessment.questions.add(Question(
            points: 0,
            questionId: questionId++, // increment after use
            questionType: 'shortAnswer',
            questionText: question['QUESTION'] ?? '',
            answer: question['ANSWER'] ?? '',
          ));
        }
      }
      if (essayQuestions.isNotEmpty) {
        for (var question in essayQuestions) {
          newAssessment.questions.add(Question(
            points: 0,
            questionId: questionId++, // increment after use
            questionType: 'essay',
            questionText: question['QUESTION'] ?? '',
            rubric: question['RUBRIC'] is String ? question['RUBRIC'] : '',
          ));
        }
      }
      assessmentList.add(newAssessment);
    }

    return assessmentList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssessmentProvider, UserProvider>(
        builder: (context, assessmentProvider, userProvider, child) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 5,
                    ),
                  ),
                );
                // build the original prompt
                // TODO we need a way to specify what saved assessment we want to provide as an example. Last two parameters.
                questionGenerationDetail.prompt = llmService.buildPrompt(
                    questionGenerationDetail.topic,
                    assessmentProvider,
                    questionGenerationDetail.isMathQuiz,
                    exampleAssessmentSetIndex,
                    exampleAssessmentIndex);
                // create the client and assessmentSet to add to
                Client client = Client();
                AssessmentSet assessmentSet = AssessmentSet(
                    [],
                    assessmentName,
                    Course(courseId, courseName,
                        topic)); // course is always generated for now
                // this gets incremented with each new assessment
                int assessmentId = 0;
                // manually check for error
                bool wasError = false;
                // check the count of requests because it might be stuck in an endless loop.
                int requestCount = 0;
                // while we don't have the right number, we need to request the llm for more assessments
                int generatedAssessmentsCount = 0;

                while (generatedAssessmentsCount <
                    questionGenerationDetail.numberOfAssessments) {
                  //try {
                  if (requestCount >
                      questionGenerationDetail.numberOfAssessments + 1) {
                    throw Exception('Endless Loop in LLM requests');
                  }
                  // make a request to the llm with the prompt
                  Response res = await llmService.sendRequest(
                      client, questionGenerationDetail.prompt);
                  // on success
                  if (res.statusCode == 200) {
                    final finalResponse = res.body;

                    String? output = finalResponse;
                    // save the output to create thread behavior
                    llmService.addMessage(output);
                    // parse the whole output one assessment at a time
                    var (extractedAssessments, rest) =
                        llmService.extractAssessments(output) ?? (null, null);
                    output = rest;
                    List<Assessment> newAssessments = getAssessmentFromOutput(
                        extractedAssessments ?? [], assessmentId++);
                    if (newAssessments.isNotEmpty) {
                      for (var assessment in newAssessments) {
                        assessmentSet.assessments.add(assessment);
                      }

                      //assessmentProvider.saveAssessmentsToFile;
                      generatedAssessmentsCount =
                          assessmentSet.assessments.length;
                    } else {
                      textEditingController.text =
                          'Recieved empty response from LLM';
                      wasError = true;
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      break;
                    }
                    questionGenerationDetail.prompt =
                        llmService.getMoreAssessmentsPrompt(assessmentProvider);
                    requestCount++;
                  } else {
                    textEditingController.text =
                        'Something went wrong with the request to Perplexity';
                    wasError = true;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    break;
                  }
                  /*} catch (e) {
                    textEditingController.text =
                        'Something went wrong with parsing the returned data';
                    wasError = true;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    //print(e);
                    break;
                  }*/
                }
                // if we get here, we add the result set to state
                // delete extra assessments if necessary
                if (!wasError) {
                  while (assessmentSet.assessments.length >
                      questionGenerationDetail.numberOfAssessments) {
                    assessmentSet.assessments.removeLast();
                  }
                  assessmentProvider.addAssessmentSet(assessmentSet);
                  // can't save to file using web browser
                  if (!kIsWeb) {
                    assessmentProvider.saveAssessmentsToFile();
                  }
                  //print('Success!');
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil(
                        (route) => route.settings.name == '/dashboard');
                  }
                }
              }
            },
            child: const Text('Generate Assessment'),
          ),
          TextField(
            enabled: false,
            style: const TextStyle(color: Colors.red),
            controller: textEditingController,
          )
        ],
      );
    });
  }
}
