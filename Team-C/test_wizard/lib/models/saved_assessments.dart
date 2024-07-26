import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/services/document_directory_service.dart';

part 'saved_assessments.g.dart';

@JsonSerializable(explicitToJson: true)
class SavedAssessments {
  final DocumentDirectoryService _documentDirectoryService = DocumentDirectoryService("assessments");

  List<AssessmentSet> assessmentSets = [];

  SavedAssessments() {
    loadAssessmentsFromFile();
  }

  factory SavedAssessments.fromJson(Map<String, dynamic> json) {
    return SavedAssessments()
      ..assessmentSets = (json['assessmentSets'] as List<dynamic>?)
              ?.map((e) => AssessmentSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
  }

  Map<String, dynamic> toJson() => _$SavedAssessmentsToJson(this);

  Future<void> saveAssessmentsToFile() async {
    await _documentDirectoryService.writeJsonToFile(toJson());
  }

  Future<void> loadAssessmentsFromFile() async {
    try {
      Map<String, dynamic> json = await _documentDirectoryService.readJsonFromFile();
      assessmentSets = SavedAssessments.fromJson(json).assessmentSets;
    } catch (e) {
      print("Error loading assessments from file: $e");
      assessmentSets = [];
    }
  }
}
