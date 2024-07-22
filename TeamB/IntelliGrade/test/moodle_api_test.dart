import 'package:intelligrade/api/moodle/moodle_api_singleton.dart';
import 'package:intelligrade/controller/model/beans.dart';

// Test for MoodleApiSingleton class.
void main() async {

  // set this to true to test operations that write to Moodle.
  bool enableWrite = true;

  var moodleApi = MoodleApiSingleton();
  print('Login Test');
  print('--------------------');
  try {
    await moodleApi.login('tzhu', 'Good4TeamB!');
    print('Login successful!');
  } catch (e) {
    print(e);
  }

  print('\nGet courses test');
  print('--------------------');
  try {
    List<Course> courses = await moodleApi.getCourses();
    for (Course c in courses) {
      print('Course: [id = ${c.id}, shortName = ${c.shortName}, fullName = ${c.fullName}');
    }
  } catch (e) {
    print(e);
  }

  if (enableWrite) {
    print('\nImport quiz test');
    print('--------------------');
    try {
      String courseId = '2';
      String xml = '<?xml version="1.0" encoding="UTF-8"?> <quiz> <question type="category"> <category> <text>\$course\$/top/Default for Intro to CS</text>  </category>  <info format="moodle_auto_format"> <text>The default category for questions shared in context \'Intro to CS\'.</text></info><idnumber></idnumber></question> <question type="essay"> <name> <text>moodle_api_test Test Import Question</text> </name> <questiontext format="html"> <text><![CDATA[<p>This is a test to import a question.</p>]]></text> </questiontext> <generalfeedback format="html"> <text></text> </generalfeedback> <defaultgrade>1</defaultgrade> <penalty>0</penalty> <hidden>0</hidden> <idnumber></idnumber> <responseformat>editorfilepicker</responseformat> <responserequired>1</responserequired> <responsefieldlines>10</responsefieldlines> <minwordlimit></minwordlimit> <maxwordlimit></maxwordlimit> <attachments>1</attachments> <attachmentsrequired>1</attachmentsrequired> <maxbytes>1048576</maxbytes> <filetypeslist></filetypeslist> <graderinfo format="html"> <text><![CDATA[<p>Information for Graders is shown here.</p>]]></text> </graderinfo> <responsetemplate format="html"> <text></text> </responsetemplate> </question> </quiz>';
      await moodleApi.importQuiz(courseId, xml);
      print('Questions successfully imported!');
    } catch (e) {
      print(e);
    }
  }
}