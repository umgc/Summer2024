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
import 'package:test_wizard/providers/assessment_state.dart';
import 'package:test_wizard/services/llm_service.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/providers/user_provider.dart';

class QuestionGenerateForm extends StatefulWidget {
  final String assessmentName;
  final int numberOfAssessments;
  final String topic;
  final String courseName;
  const QuestionGenerateForm({
    super.key,
    required this.assessmentName,
    required this.numberOfAssessments,
    required this.topic,
    required this.courseName,
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
        var state = AssessmentState(assessmentId: 0, version: 0);
        state.add(Question(
          points: 0,
          questionId: id++,
          questionText: '',
          questionType: 'Short Answer',
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
                    child: Consumer<AssessmentState>(
                      builder: (context, assessment, child) {
                        return Column(
                          children: <Widget>[
                            ...assessment.questions.map(
                              (question) {
                                return Column(children: [
                                  AddedQuestion(
                                    question: question,
                                    assessment: assessment,
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
                                assessment.add(Question(
                                  questionId: id++,
                                  points: 0,
                                  questionText: '',
                                  questionType: 'Multiple Choice',
                                ));
                              },
                              child: const Text('Add Question'),
                            ),
                            GenerateAssessmentsButton(
                              formKey: _formKey,
                              textEditingController: textEditingController,
                              llmService: llmService,
                              questionGenerationDetail:
                                  questionGenerationDetail,
                              assessment: assessment,
                              assessmentName: widget.assessmentName,
                              courseName: widget.courseName,
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
  final AssessmentState assessment;
  final Question question;
  final TextEditingController controller;

  AddedQuestion({
    super.key,
    required this.question,
    required this.assessment,
  }) : controller = TextEditingController.fromValue(
          TextEditingValue(
            text: question.questionText,
            selection: TextSelection.collapsed(
              offset: assessment.cursorPos,
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
                  value: 'Multiple Choice',
                  child: Text('Multiple Choice'),
                ),
                DropdownMenuItem(
                  value: 'Short Answer',
                  child: Text('Short Answer'),
                ),
                DropdownMenuItem(
                  value: 'Essay',
                  child: Text('Essay'),
                ),
              ],
              onChanged: (value) {
                int newPos = controller.selection.baseOffset;
                assessment.update(
                    id: question.questionId, newType: value, newPos: newPos);
              }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value) {
              int newPos = controller.selection.baseOffset;
              assessment.update(
                  id: question.questionId, newText: value, newPos: newPos);
            },
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
          onPressed: () => assessment.remove(question.questionId),
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
  final AssessmentState assessment;
  final String assessmentName;
  final String courseName;

  const GenerateAssessmentsButton({
    super.key,
    required this.formKey,
    required this.textEditingController,
    required this.llmService,
    required this.questionGenerationDetail,
    required this.assessment,
    required this.assessmentName,
    required this.courseName,
  });

  Assessment getAssessmentFromOutput(Map<String, dynamic> output, int id) {
    int questionId = 0; // same thing as assessmentId
    // generate a new assessment from the extracted
    List<dynamic>? multipleChoiceQuestions = output['multipleChoice'] ?? [];
    List<dynamic>? shortAnswerQuestions = output['shortAnswer'] ?? [];
    List<dynamic>? essayQuestions = output['essay'] ?? [];
    Assessment newAssessment =
        Assessment(id, id++); // increment assessmentId after using
    if (multipleChoiceQuestions != null) {
      for (var question in multipleChoiceQuestions) {
        newAssessment.questions.add(Question(
          points: 0,
          questionId: questionId++, // increment after use
          questionType: 'Multiple Choice',
          questionText: question['QUESTION'] ?? '',
          answer:
              question['ANSWER'] != null ? question['ANSWER'].toString() : '',
          answerOptions: question['OPTIONS'] != null
              ? question['OPTIONS'].cast<String>()
              : [],
        ));
      }
    }
    if (shortAnswerQuestions != null) {
      for (var question in shortAnswerQuestions) {
        newAssessment.questions.add(Question(
          points: 0,
          questionId: questionId++, // increment after use
          questionType: 'Short Answer',
          questionText: question['QUESTION'] ?? '',
          answer: question['ANSWER'] ?? '',
        ));
      }
    }
    if (essayQuestions != null) {
      for (var question in essayQuestions) {
        newAssessment.questions.add(Question(
          points: 0,
          questionId: questionId++, // increment after use
          questionType: 'Essay',
          questionText: question['QUESTION'] ?? '',
          rubric: question['RUBRIC'] is String ? question['RUBRIC'] : '',
        ));
      }
    }
    return newAssessment;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
        builder: (context, savedAssessments, child) {
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
                questionGenerationDetail.prompt = llmService.buildPrompt(
                    questionGenerationDetail.topic,
                    assessment,
                    questionGenerationDetail.isMathQuiz);
                // create the client and resultSet to add to
                Client client = Client();
                AssessmentSet resultSet = AssessmentSet(
                    [],
                    assessmentName,
                    Course(
                        0, courseName)); // course is always generated for now
                // this gets incremented with each new assessment
                int assessmentId = 0;
                // manually check for error
                bool wasError = false;
                // check the count of requests because it might be stuck in an endless loop.
                int requestCount = 0;
                // while we don't have the right number, we need to request the llm for more assessments
                while (resultSet.assessments.length <
                    questionGenerationDetail.numberOfAssessments) {
                  try {
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
                      while (output != null) {
                        var (extractedAssessment, rest) =
                            llmService.extractAssessment(output) ??
                                (null, null);
                        output = rest;

                        if (extractedAssessment != null) {
                          Assessment newAssessment = getAssessmentFromOutput(
                              extractedAssessment, assessmentId++);
                          resultSet.assessments.add(newAssessment);
                        }
                      }
                      questionGenerationDetail.prompt =
                          llmService.getMoreAssessmentsPrompt(assessment);
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
                  } catch (e) {
                    textEditingController.text =
                        'Something went wrong with parsing the returned data';
                    wasError = true;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    print(e);
                    break;
                  }
                }
                // if we get here, we add the result set to state
                // delete extra assessments if necessary
                if (!wasError) {
                  while (resultSet.assessments.length >
                      questionGenerationDetail.numberOfAssessments) {
                    resultSet.assessments.removeLast();
                  }
                  savedAssessments.add(resultSet);
                  // can't save to file using web browser
                  if (!kIsWeb) {
                    savedAssessments.saveAssessmentsToFile();
                  }
                  print('Success!');
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil(
                        (route) => route.settings.name == '/dashboard');
                  }
                }
              }
              // add quiz to moodle
              UserProvider userProvider = Provider.of<UserProvider>(context);
              if(userProvider.isLoggedInToMoodle) {
                // savedAssessments
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
