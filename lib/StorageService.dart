import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static Database? _database;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, create it
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the directory for the app's private files
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'transcripts.db');

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database schema
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transcripts (
        transcript_id INTEGER PRIMARY KEY AUTOINCREMENT,
        transcript_name TEXT NOT NULL,
        transcript_content TEXT NOT NULL,
        summarization TEXT,
        keywords TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> deleteTable() async{
    Database db = await database;
    await db.execute('''
      DROP TABLE transcripts 
    ''');
  }

  // Insert a text file into the database
  Future<int> insertTranscriptFile(String name, String content) async {
    Database db = await database;
    DateTime now = DateTime.now();
    String localTime = DateFormat('MM-dd-yyyy HH:mm:ss').format(now);
    return await db.insert(
      'transcripts',
      {
        'transcript_name': name,
        'transcript_content': content,
        'created_at': localTime,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future updateTranscriptFile(
      String name, String content, String keywords, String summary, String previousName) async {
    Database db = await database;   
     var numchanges = await db.rawUpdate('UPDATE transcripts SET transcript_name = \'' +
        name +
        '\', summarization = \'' +
        summary +
        '\', keywords = \'' +
        keywords +
        '\' WHERE transcript_name = \'' +
        previousName + '\'');
        //print(numchanges);
  }

  // Retrieve all text files from the database
  Future<List<Map<String, dynamic>>> getTranscripts() async {
    Database db = await database;
    return await db.rawQuery('SELECT * FROM transcripts ORDER BY created_at DESC');
  }

 // Retrieve all text files from the database
  Future<List<Map<String, dynamic>>> getLatestTranscript() async {
    Database db = await database;
    return await db.rawQuery('SELECT transcript_content FROM transcripts ORDER BY created_at DESC LIMIT 10');
  }

  // Retrieve all text files from the database
  Future<List<Map<String, dynamic>>> getTranscript(int id) async {
    Database db = await database;
    return await db.rawQuery('SELECT * FROM transcripts WHERE transcript_id = ' + id.toString());
  }

  // Delete a text file by id
  Future<int> deleteTranscript(int id) async {
    Database db = await database;
    return await db.delete('transcripts', where: 'id = ?', whereArgs: [id]);
  }
}
