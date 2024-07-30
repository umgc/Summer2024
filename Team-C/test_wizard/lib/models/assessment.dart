import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/question.dart';

part 'assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class Assessment {
  //this will not affect question generation. Informational only when integrated with moodle.
  int assessmentId;
  //Unique version of the assessment
  int assessmentVersion;
  //Determines whether this assessment is purely an example for the LLM
  bool isExampleAssessment;
  //List of questions related to the assessment
  List<Question> questions = [];

  Assessment(
      this.assessmentId, this.assessmentVersion, this.isExampleAssessment);

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentToJson(this);

  String getAssessmentAsJson() {
    JsonEncoder encoder = const JsonEncoder();
    var map = {"multipleChoice": [], "shortAnswer": [], "essay": []};
    for (var question in questions) {
      switch (question.questionType) {
        case "Multiple Choice":
          map['multipleChoice']!.add({"QUESTION": question.questionText});
          break;
        case "Short Answer":
          map['shortAnswer']!.add({"QUESTION": question.questionText});
          break;
        case "Essay":
          map['essay']!.add({"QUESTION": question.questionText});
          break;
        default:
          continue;
      }
    }
    try {
      String json = encoder.convert(map);
      return json;
    } catch (e) {
      return '';
    }
  }
}
