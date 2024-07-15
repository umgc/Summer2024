import 'question.dart'; 

class Assessment {
  final int id;
  final String name;
  final List<Question> questions;

  Assessment({required this.id, required this.name, required this.questions});

  factory Assessment.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson.map((questionJson) => Question.fromJson(questionJson)).toList();

    return Assessment(
      id: json['id'],
      name: json['name'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'questions': questions?.map((question) => question.toJson()).toList(),
    };
  }
}