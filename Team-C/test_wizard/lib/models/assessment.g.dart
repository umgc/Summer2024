// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assessment _$AssessmentFromJson(Map<String, dynamic> json) => Assessment(
      (json['assessmentId'] as num).toInt(),
      json['assessmentName'] as String,
      json['gradedOn'] as String,
    )
      ..course = json['course'] == null
          ? null
          : Course.fromJson(json['course'] as Map<String, dynamic>)
      ..questions = (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$AssessmentToJson(Assessment instance) =>
    <String, dynamic>{
      'assessmentId': instance.assessmentId,
      'assessmentName': instance.assessmentName,
      'gradedOn': instance.gradedOn,
      'course': instance.course?.toJson(),
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };
