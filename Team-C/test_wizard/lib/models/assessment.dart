import 'package:test_wizard/models/question.dart';

class Assessment {

  //this will not affect question generation. Informational only when integrated with moodle.
  String course = "";

  //what system the assessment is graded on. 
  String gradedOn = "";

  List<Question> questions = [];

  Assessment();
}

