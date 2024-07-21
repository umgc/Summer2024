// lib/api/question.dart

class Question {
  final String text;
  final String type;
  final String response;

  Question({required this.text, required this.type, required this.response});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      type: json['type'],
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'response': response,
    };
  }
}
