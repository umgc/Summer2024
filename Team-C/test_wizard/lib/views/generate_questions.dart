import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/models/question_generation_detail.dart';
import 'package:test_wizard/providers/assessment_state.dart';
import 'package:test_wizard/services/llm_service.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

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

  String prompt = "";
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
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  var typeMap =
                                      assessment.getQuestionTypeCount();
                                  int multipleChoiceCount =
                                      typeMap['Multiple Choice']!;
                                  int shortAnswerCount =
                                      typeMap['Short Answer']!;
                                  int essayCount = typeMap['Essay']!;
                                  print(multipleChoiceCount);
                                  print(shortAnswerCount);
                                  print(essayCount);

                                  questionGenerationDetail.prompt =
                                      llmService.buildPrompt(
                                          questionGenerationDetail
                                              .numberOfAssessments,
                                          questionGenerationDetail.topic);
                                  textEditingController.text =
                                      questionGenerationDetail.prompt;
                                }
                              },
                              child: const Text('Generate Assessment'),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Generated Prompt will go here'),
                              controller: textEditingController,
                              onChanged: (value) {
                                questionGenerationDetail.prompt = value;
                              },
                              minLines: 4,
                              maxLines: 10,
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
            onChanged: (value) =>
                assessment.update(id: question.questionId, newType: value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: (value) =>
                assessment.update(id: question.questionId, newText: value),
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
