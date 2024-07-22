import 'package:flutter/material.dart';
import 'package:test_wizard/models/question_generation_detail.dart';
import 'package:test_wizard/services/llm_service.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class QuestionGenerateForm extends StatefulWidget {
  final String assessmentName;
  final int numberOfAssessments;
  final String topic;
  const QuestionGenerateForm({
    super.key,
    required this.assessmentName,
    required this.numberOfAssessments,
    required this.topic,
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

  QuestionGenerationDetail questionGenerationDetail =
      QuestionGenerationDetail();

  String prompt = "";
  bool isMathQuiz = false;
  List<Map<String, String>> questions = [
    {'questionType': 'Multiple Choice', 'questionText': ''},
  ];

  // [multiple choice] - [What is 2 + 2?] [x]
  // short answer - What is 3 + 2? x
  // Essay - Explain why 3 + 3 = 6? x
  // [add question]

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

  void _removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TWAppBar(
        context: context,
        screenTitle: 'Add Questions to ${widget.assessmentName}',
        implyLeading: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: screenSize.width * 0.9,
                child: Column(
                  children: <Widget>[
                    ...questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, String> question = entry.value;
                      return SizedBox(
                        child: AddedQuestion(
                          questionText: question['questionText'],
                          questionType: question['questionType'],
                          onRemove: () => _removeQuestion(index),
                        ),
                      );
                    }).toList(),
                    Checkbox(
                        value: isMathQuiz,
                        onChanged: (value) {
                          setIsMathQuiz();
                        }),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          questions.add(
                            {
                              'questionType': 'Multiple Choice',
                              'questionText': ''
                            },
                          );
                        });
                      },
                      child: const Text('Add Question'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //TODO add Addtional Details and Question Type Count
                          questionGenerationDetail.prompt =
                              llmService.buildPrompt(
                                  questionGenerationDetail.numberOfAssessments,
                                  questionGenerationDetail.topic);
                          textEditingController.text =
                              questionGenerationDetail.prompt;
                          print(questions);
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddedQuestion extends StatefulWidget {
  final String? questionType;
  final String? questionText;
  final VoidCallback onRemove;

  const AddedQuestion({
    super.key,
    this.questionText,
    this.questionType = 'Multiple Choice',
    required this.onRemove,
  });

  @override
  State<AddedQuestion> createState() => AddedQuestionState();
}

class AddedQuestionState extends State<AddedQuestion> {
  String? questionType = 'Multiple Choice';
  String? questionText;
  TextEditingController? controller;

  @override
  void initState() {
    questionType = widget.questionType;
    questionText = widget.questionText;
    controller = TextEditingController(text: widget.questionText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Form(
        child: Row(
          children: [
            SizedBox(
              width: 175,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: questionType,
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
                  setState(() {
                    questionType = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'What is 2 + 2?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: widget.onRemove,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
