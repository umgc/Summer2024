import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mindinsync/KnowledgeService.dart';
import 'package:mindinsync/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'Drawer.dart';
import 'BottomNavigation.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({Key? key}) : super(key: key);

  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  List<File> _uploadedFiles = [];
  KnowledgeService knowledge = KnowledgeService();
  DBHelper db = DBHelper();

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      // allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
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

  void insertKnowledge(content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("userEmail");
    String userId = await db.getUserId(email!);
    knowledge.setKnowledge(content, userID);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('File Uploaded Succesfully!')));
  }

  void removeKnowledge(content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("userEmail");
    String userId = await db.getUserId(email!);
    knowledge.removeKnowledge(content, userID);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('File Deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload'),
        backgroundColor: Colors.blue[300],
        foregroundColor: Colors.indigo[800],
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
                  final file = _uploadedFiles[index];
                  final fileName = path.basename(file.path);
                  final fileDate = DateTime.fromMillisecondsSinceEpoch(
                      file.lastModifiedSync().millisecondsSinceEpoch);
                  final formattedDate =
                      'Created Date: ${fileDate.month}/${fileDate.day}/${fileDate.year}';

                  return Dismissible(
                    key: Key(file.path),
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
                      title: Text(fileName),
                      subtitle: Text(
                        formattedDate,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      onTap: () {
                        _openFile(file);
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
      drawer: const DrawerMenu(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index for the Home screen
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/Search');
              break;
            case 2:
              
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Future<void> _openFile(File file) async {
    final fileExtension = path.extension(file.path).toLowerCase();

    if (fileExtension == '.png' || fileExtension == '.jpg') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(path.basename(file.path)),
          content: Image.file(file),
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
    } else {
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
              child: const Text('Upload'),
              onPressed: () {
                insertKnowledge(content);
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                removeKnowledge(content);
              },
            ),
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
}
