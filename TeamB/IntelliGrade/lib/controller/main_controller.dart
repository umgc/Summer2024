import 'assessment.dart';
import 'assessment_generator.dart';
import 'assessment_grader.dart';

class MainController {
  final AssessmentGenerator assessmentGenerator = AssessmentGenerator(serverUrl: '');//TODO
  final AssessmentGrader assessmentGrader = AssessmentGrader();

  void createAssessment() {
    // Assessment assessment = assessmentGenerator.generateAssessment();
    // Handle the creation logic
  }

  void viewAssessment() {
    // Handle viewing logic
  }

  void settings() {
    // Handle settings logic
  }

  void gradeAssessment() {
    // Assessment assessment = assessmentGenerator.generateAssessment();
    // Assessment gradedAssessment = assessmentGrader.gradeAssessment(assessment);
    // Handle grading logic
  }
}
