import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course {
  // Name of the course
  String courseName;
  // Moodle Course Id
  int courseId;
  // Topic of the course
  String topic;

  Course(this.courseId, this.courseName, this.topic);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
