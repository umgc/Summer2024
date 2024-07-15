import 'package:test_wizard/models/question.dart';

class Assessment {
  List<String> course = ['Select Course'];
  List<String> assessmentType = ['Select Assessment Type', 'Short Answer', 'Multiple Choice', 'Essay'];
  List<String> gradedOn = ['Select Graded On', 'Standards', 'Points'];
  List<Question> questions = [];

  Assessment();

  List<String> getCourses(){
    return course;
  }

  List<String> getAssessmentType(){
    return assessmentType;
  }

  List<Question> getQuestions(){
    return questions;
  }
}

