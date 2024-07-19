import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  //unique identifier for the question
  int questionId;
  //text describing the question
  String questionText;
  //Type of question
  String questionType;
  //Answer to the question. Null for exteneded response
  String? answer;
  //Grading rubric for extended response questions. Null for multiple choice. 
  String? rubric;
  //number of points the question is worth.
  int points;
  //Answer Options, answer is included in this list.
  List<String>? answerOptions = [];

  Question(this.questionId,this.questionText,this.questionType,this.answer,this.rubric,this.points,this.answerOptions);

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}