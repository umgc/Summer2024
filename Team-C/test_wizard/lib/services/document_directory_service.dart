import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DocumentDirectoryService{

  static const JsonDecoder decoder = JsonDecoder();

  //type of file to get
  String model;

  DocumentDirectoryService(this.model);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$model.txt');
  }

  Future<Map<String, dynamic>> readJsonFromFile() async {

    Map<String, dynamic> json = <String, dynamic>{};

    try {
        final file = await _localFile;

        // Read the file
        final contents = await file.readAsString();
        json = decoder.convert(contents);
        return json;
      } catch (e) {
        // If encountering an error, return empty map.
        return json;
      }
  }

  Future<File> writeJsonToFile(Map<String, dynamic> json) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$json');
  }
}