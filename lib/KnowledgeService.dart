import 'package:flutter/material.dart';
import '../mysql.dart';



class KnowledgeService {
static final KnowledgeService _instance = KnowledgeService._internal();


factory KnowledgeService() {
    return _instance;
  }

   var db = new Mysql();
  var knowledgeBaseSuffix = '';
  var knowledgeLoaded = "";

  KnowledgeService._internal();

  // biometric data
  // username -> device name

 
  Future<String> getKnowledge(int userId) async{
    String knowledge = "";
    knowledgeLoaded = "";
     await db.getConnection().then((conn)  async {
      // This needs needs a User ID to get the appropriate knowledge base contents.
      String sql = "SELECT * FROM KnowledgeBase WHERE UserID = " + userId.toString();
       var temp = await conn.query(sql).then((results) {
        for (var row in results) {
            //print(row[1]);
            knowledgeLoaded += row[1] + '.\n';
        }
        print (knowledgeLoaded);
        db.closeConnection(conn);
      });
      
    });
    return knowledge;
  }

  void setKnowledge(String str) {
    db.getConnection().then((conn) {
      // This needs to grab the stored user ID to set it appropriatly.
      String sql =
          "INSERT INTO KnowledgeBase (Information, UserID) VALUES ('$str', 1)";
      conn.query(sql);
      db.closeConnection(conn);
    });
  }
  
 


}