// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionId: (json['questionId'] as num).toInt(),
      questionText: json['questionText'] as String,
      questionType: json['questionType'] as String,
      answer: json['answer'] as String?,
      rubric: json['rubric'] as String?,
      points: (json['points'] as num).toInt(),
      answerOptions: (json['answerOptions'] as List<dynamic>?)
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
