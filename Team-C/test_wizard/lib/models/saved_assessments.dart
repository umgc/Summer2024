import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/services/document_directory_service.dart';

part 'saved_assessments.g.dart';

@JsonSerializable(explicitToJson: true)
class SavedAssessments {
  final DocumentDirectoryService _documentDirectoryService =
      DocumentDirectoryService("assessments");

  List<AssessmentSet> assessmentSets = [];

  SavedAssessments() {
    loadAssessmentsFromFile();
  }

  factory SavedAssessments.fromJson(Map<String, dynamic> json) =>
      _$SavedAssessmentsFromJson(json);

  Map<String, dynamic> toJson() => _$SavedAssessmentsToJson(this);

  Future<void> saveAssessmentsToFile() async {
    await _documentDirectoryService.writeJsonToFile(toJson());
  }

  Future<void> loadAssessmentsFromFile() async {
    try{
      assessmentSets = SavedAssessments.fromJson(
              await _documentDirectoryService.readJsonFromFile())
          .assessmentSets;
    }catch(e){
      assessmentSets = [];
    }
  }
}
