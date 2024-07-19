// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      (json['questionId'] as num).toInt(),
      json['questionText'] as String,
      json['questionType'] as String,
      json['answer'] as String?,
      json['rubric'] as String?,
      (json['points'] as num).toInt(),
      (json['answerOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'questionType': instance.questionType,
      'answer': instance.answer,
      'rubric': instance.rubric,
      'points': instance.points,
      'answerOptions': instance.answerOptions,
    };
