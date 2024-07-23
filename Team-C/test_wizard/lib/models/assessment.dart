import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/question.dart';

part 'assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class Assessment {
  //this will not affect question generation. Informational only when integrated with moodle.
  int assessmentId;
  //Unique version of the assessment
  int assessmentVersion;
  //List of questions related to the assessment
  List<Question> questions = [];

  Assessment(this.assessmentId, this.assessmentVersion);

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentToJson(this);
}
