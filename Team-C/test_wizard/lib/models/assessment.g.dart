// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Assessment _$AssessmentFromJson(Map<String, dynamic> json) => Assessment(
      (json['assessmentId'] as num).toInt(),
      (json['assessmentVersion'] as num).toInt(),
    )..questions = (json['questions'] as List<dynamic>)
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$AssessmentToJson(Assessment instance) =>
    <String, dynamic>{
      'assessmentId': instance.assessmentId,
      'assessmentVersion': instance.assessmentVersion,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
    };
