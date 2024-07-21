import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QuestionGenerationDetail {
  //academic subject
  String subject = "";

  //Specific information on the a sub-section of the subject
  String topic = "";

  //Number of Assessments for the LLM to generate
  int numberOfAssessments = 1;

  //Number of Assessments generated
  int numberOfAssessmentsGenerated = 0;

  //Type of Assessment to generate: Quiz, Test, Exam
  String assessmentType = "Quiz";

  //Question Type - Multiple Choice, Essay, Extended Response: Question Type Count
  var questionType = {'multipleChoice': 0, 'Essay': 0, 'extendedResponse': 0};

  //this is to subjective and not helpful to the prompt.
  String? gradeLevel;

  //Changes the sources.
  bool _isMathQuiz = false;

  //identify how to set focus
  //limits the sources the questions are generated from.
  String _sourceCriteria = "all";

  //Id of the Json object containing the quiz.
  int exampleQuiz = 0;

  //No plan to implement for this MVP
  //Additional Text to add to the prompt.
  String? additionalDetail;

  String prompt = "";

  QuestionGenerationDetail();

//IsMathQuiz
  bool get isMathQuiz => _isMathQuiz;

  set isMathQuiz(bool? isMathQuiz) {
    _isMathQuiz = !_isMathQuiz;
    if (_isMathQuiz == true) {
      _sourceCriteria = "math";
    }
    if (_isMathQuiz == false) {
      _sourceCriteria = "all";
    }
  }

  //SourceCriteria
  String get sourceCriteria => _sourceCriteria;
}
