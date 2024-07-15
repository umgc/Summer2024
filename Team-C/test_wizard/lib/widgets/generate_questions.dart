import 'package:flutter/material.dart';
import 'package:test_wizard/services/llm_service.dart';

class QuestionGenerateForm extends StatefulWidget{
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final"
  QuestionGenerateForm({super.key});

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

  //academic subject
  String subject = "";

  //Specific information on the a sub-section of the subject
  String topic = "";

  //Number of Assessments for the LLM to generate
  int numberOfAssessments = 0;

  //Type of Assessment to generate: Quiz, Test, Exam
  String assessmentType = "";

  //this is to subjective and not helpful to the prompt.
  String gradeLevel = "";

  //Changes the sources. 
  bool isMathQuiz = false;

  //identify how to set focus
  //limits the sources the questions are generated from.
  String sourceCriteria = "all";

  //Id of the Json object containing the quiz. 
  int exampleQuiz = 0;

  //No plan to implement for this MVP
  //Additional Text to add to the prompt.
  String additionalDetail = "";

  String prompt = "";

  void setTopic(String topic) {
    setState(() {
      topic = topic;
    });
  }

  void setSubject(String subject) {
    setState(() {
      subject = subject;
    });
  }

  void setNumberOfAssessment(int numberOfAssessments) {
    setState(() {
      numberOfAssessments = numberOfAssessments;
    });
  }

  void setAdditionalDetail(String additionalDetail) {
    setState(() {
      additionalDetail = additionalDetail;
    });
  }

  void setAssessmentType(String assessmentType) {
    setState(() {
      assessmentType = assessmentType;
    });
  }

  bool setIsMathQuiz(bool value) {
    setState(() {
      isMathQuiz = value;
    });
    sourceCriteria = "math";
    return isMathQuiz;
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(child: 
          Column( children:  <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              setSubject(value);
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Subject',
              border: OutlineInputBorder()
            )
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              setTopic(value);
              return null;
            },
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              setAdditionalDetail(value);
              return null;
            },
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              setAssessmentType(value);
              return null;
            },
          ),
          Checkbox(value: isMathQuiz, onChanged: (value) {setIsMathQuiz(value!);}),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()){
                llmService.buildPompt(numberOfAssessments,assessmentType, subject, topic);
              }
            },
            child: const Text('Generate'),
          ),
      ]))],
      )
    );
  }
}