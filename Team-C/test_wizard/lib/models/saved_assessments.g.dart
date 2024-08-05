// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_assessments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedAssessments _$SavedAssessmentsFromJson(Map<String, dynamic> json) =>
    SavedAssessments()
      ..assessmentSets = (json['assessmentSets'] as List<dynamic>)
          .map((e) => AssessmentSet.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SavedAssessmentsToJson(SavedAssessments instance) =>
    <String, dynamic>{
      'assessmentSets': instance.assessmentSets.map((e) => e.toJson()).toList(),
    };
