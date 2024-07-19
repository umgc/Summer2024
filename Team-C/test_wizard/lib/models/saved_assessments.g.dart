// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_assessments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedAssessments _$SavedAssessmentsFromJson(Map<String, dynamic> json) =>
    SavedAssessments()
      ..assessments = (json['assessments'] as List<dynamic>)
          .map((e) => Assessment.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SavedAssessmentsToJson(SavedAssessments instance) =>
    <String, dynamic>{
      'assessments': instance.assessments.map((e) => e.toJson()).toList(),
    };
