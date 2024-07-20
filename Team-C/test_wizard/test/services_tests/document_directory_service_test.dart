import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/services/document_directory_service.dart';


void main() {
  group('document_directory_service', () {
    test('constructor correctly instantiates class', () {
      final dds = DocumentDirectoryService('assessments');
      expect(dds.model, 'assessments');
    });

    test('makes call to API', () async {
      final dds = DocumentDirectoryService('assessments');
      
    });
  });
}
