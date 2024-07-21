import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'stml-db.cv4gckmos8ci.us-east-1.rds.amazonaws.com',
      user = 'admin',
      password = 'JUQ0qVlf2QQW5HXSKmXB',
      db = 'MindInSync';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }

  void closeConnection(conn) async {
    await conn.close();
  }

}