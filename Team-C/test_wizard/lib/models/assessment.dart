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


  Assessment(this.assessmentId, this.assessmentVersion, this.isExampleAssessment);


  factory Assessment.fromJson(Map<String, dynamic> json) =>
      _$AssessmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentToJson(this);

  String getAssessmentAsJson() {
    JsonEncoder encoder = const JsonEncoder();
    var map = {"multipleChoice": [], "shortAnswer": [], "essay": []};
    for (var question in questions) {
      switch (question.questionType) {
        case "multipleChoice":
          map['multipleChoice']!.add({"QUESTION": question.questionText});
          break;
        case "shortAnswer":
          map['shortAnswer']!.add({"QUESTION": question.questionText});
          break;
        case "essay":
          map['essay']!.add({"QUESTION": question.questionText});
          break;
        default:
          continue;
      }
    }
    try {
      String json = encoder.convert(map);
      json = '[{$json}]';
      return json;
    } catch (e) {
      return '';
    }
  }
}
