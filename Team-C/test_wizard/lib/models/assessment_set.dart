import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/course.dart';

part 'assessment_set.g.dart';

@JsonSerializable(explicitToJson: true)
class AssessmentSet{

  //List of unique assessments.
  late List<Assessment> assessments = [];
  //name of the assessment
  String assessmentName;
  //Course information related to the assessment
  Course? course;

  AssessmentSet(this.assessments, this.assessmentName, this.course);

  factory AssessmentSet.fromJson(Map<String, dynamic> json) =>
      _$AssessmentSetFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentSetToJson(this);
}