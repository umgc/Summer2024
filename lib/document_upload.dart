import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({Key? key}) : super(key: key);

  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  List<File> _uploadedFiles = [];

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final savedDir = Directory('${appDir.path}/uploads');

      if (!await savedDir.exists()) {
        await savedDir.create(recursive: true);
      }

      final fileName = path.basename(file.path);
      final savedFile = await file.copy('${savedDir.path}/$fileName');

      setState(() {
        _uploadedFiles.add(savedFile);
      });
    }
  }

  void _deleteFile(int index) {
    setState(() {
      _uploadedFiles[index].deleteSync();
      _uploadedFiles.removeAt(index);
    });
  }

  Future<void> _listUploadedFiles() async {
    final appDir = await getApplicationDocumentsDirectory();
    final savedDir = Directory('${appDir.path}/uploads');
    final files = savedDir.listSync().map((item) => File(item.path)).toList();

    setState(() {
      _uploadedFiles = files;
    });
  }

  @override
  void initState() {
    super.initState();
    _listUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _uploadedFiles.isEmpty
            ? Center(
                child: Text('No files uploaded.'),
              )
            : ListView.builder(
                itemCount: _uploadedFiles.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_uploadedFiles[index].path),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      _deleteFile(index);
                    },
                    child: ListTile(
                      title: Text(path.basename(_uploadedFiles[index].path)),
                      // subtitle: Text(_uploadedFiles[index].path),
                      onTap: () {
                        _openFile(_uploadedFiles[index]);
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickDocument,
        tooltip: 'Upload Document',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[300],
      ),
    );
  }

  Future<void> _openFile(File file) async {
    final content = await file.readAsString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(path.basename(file.path)),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
