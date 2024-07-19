import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/services/document_directory_service.dart';

part 'saved_assessments.g.dart';

@JsonSerializable(explicitToJson: true)
class SavedAssessments{

  final DocumentDirectoryService _documentDirectoryService = DocumentDirectoryService("assessments");

  late List<Assessment> assessments;

  SavedAssessments() {loadAssessmentsFromFile();}

  factory SavedAssessments.fromJson(Map<String, dynamic> json) => _$SavedAssessmentsFromJson(json);

  Map<String, dynamic> toJson() => _$SavedAssessmentsToJson(this);

  void saveAssessmentsToFile(){
    _documentDirectoryService.writeJsonToFile(toJson());
  }

  void loadAssessmentsFromFile() async{
    try {
      assessments = SavedAssessments.fromJson(await _documentDirectoryService.readJsonFromFile()).assessments; 
    } catch (e) {
      assessments = [];
    }
  }
}