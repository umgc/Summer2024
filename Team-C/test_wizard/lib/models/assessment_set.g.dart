// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentSet _$AssessmentSetFromJson(Map<String, dynamic> json) =>
    AssessmentSet(
      (json['assessments'] as List<dynamic>)
          .map((e) => Assessment.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['assessmentName'] as String,
      json['course'] == null
          ? null
          : Course.fromJson(json['course'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AssessmentSetToJson(AssessmentSet instance) =>
    <String, dynamic>{
      'assessments': instance.assessments.map((e) => e.toJson()).toList(),
      'assessmentName': instance.assessmentName,
      'course': instance.course?.toJson(),
    };
