import 'package:mysql1/mysql1.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
      host:
          'stml-db.cv4gckmos8ci.us-east-1.rds.amazonaws.com', // Change to your MariaDB host
      port: 3306,
      user: 'admin', // Change to your MariaDB username
      password: 'JUQ0qVlf2QQW5HXSKmXB', // Change to your MariaDB password
      db: 'MindInSync',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<void> storeConversation(int userId, String text) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO conversations (user_id, text) VALUES (?, ?)',
      [userId, text],
    );
    await conn.close();
  }

  Future<List<Map<String, dynamic>>> getConversations(int userId) async {
    final conn = await getConnection();
    final results = await conn.query(
      'SELECT * FROM conversations WHERE user_id = ?',
      [userId],
    );

    List<Map<String, dynamic>> conversations = [];
    for (var row in results) {
      conversations.add({
        'id': row['id'],
        'user_id': row['user_id'],
        'text': row['text'],
        'recorded_at': row['recorded_at'],
      });
    }

    await conn.close();
    return conversations;
  }

  Future<void> insertAccount(String username, String password) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO Account (username, password) VALUES (?, ?)',
      [username, password],
    );
    await conn.close();
  }

  Future<void> insertUser(
      String firstname, String lastname, String email) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO User (firstname, lastname,email) VALUES (?,?,?)',
      [firstname, lastname, email],
    );
    await conn.close();
  }
}
