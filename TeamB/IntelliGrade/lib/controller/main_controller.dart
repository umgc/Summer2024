import 'assessment.dart';
import 'assessment_generator.dart';
import 'assessment_grader.dart';

class MainController {
  final AssessmentGenerator assessmentGenerator =
      AssessmentGenerator(serverUrl: ''); //TODO
  final AssessmentGrader assessmentGrader = AssessmentGrader();

  void createAssessment() {
    //will use LLM
    // Assessment assessment = assessmentGenerator.generateAssessment();
    // Handle the creation logic
  }

  void gradeAssessment() {
    //will use LLM
    // Assessment assessment = assessmentGenerator.generateAssessment();
    // Assessment gradedAssessment = assessmentGrader.gradeAssessment(assessment);
    // Handle grading logic
  }

  Assessment viewLocalAssessment(String filename) {
    // Handle viewing logic
    return Assessment();
  }

  void settings() {
    //what is this supposed to do?
    // Handle settings logic
  }

  void saveFileLocally(String assessmentAsXml) {
    // Handle saving logic
  }

  void downloadAssessmentAsPdf(String filename) {
    // Handle downloading logic
  }

  List<String> listAllAssessments() {
    // Handle listing logic
    return [];
  }

  void updateFileLocally(String assessmentAsXml) {
    // Handle updating file logic
  }

  void postAssessmentToMoodle() {
    // Handle posting logic
  }

  Assessment getAssessmentFromMoodle() {
    // Handle getting logic
    return Assessment();
  }

  String complieCodeAndGetOutput(String code) {
    // Handle compiling logic
    return '';
  }
}
