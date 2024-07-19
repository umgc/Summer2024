import 'package:test_wizard/models/course.dart';
import 'package:test_wizard/models/question.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class Assessment {
  //this will not affect question generation. Informational only when integrated with moodle.
  int assessmentId;
  //name of the assessment
  String assessmentName;
  //what system the assessment is graded on. 
  String gradedOn;
  //Course information related to the assessment
  Course? course;
  //List of questions related to the assessment
  List<Question> questions = [];

  Assessment(this.assessmentId, this.assessmentName, this.gradedOn);

  factory Assessment.fromJson(Map<String, dynamic> json) => _$AssessmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentToJson(this);
}

