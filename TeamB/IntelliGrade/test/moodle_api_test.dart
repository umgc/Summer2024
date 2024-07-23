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
      // String xml = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<quiz>\n  <question>\n    <text>Who was the main author of the Declaration of Independence?</text>\n    <options>\n      <option>A) Thomas Jefferson</option>\n      <option>B John Adams</option>\n      <option>C Benjamin Franklin</option>\n      <option>D George Washington</option>\n    </options>\n    <answer>A</answer>\n  </question>\n  <question>\n    <text>The Great Fire of 1871 occurred in which American city?</text>\n    <options>\n      <option>A New York City</option>\n      <option>B Chicago</option>\n      <option>C San Francisco</option>\n      <option>D Boston</option>\n    </options>\n    <answer>B</answer>\n  </question>\n</quiz>';
      String xml2 = '<?xml version="1.0" encoding="UTF-8"?><quiz><question type="category"> <category> <text>\$course\$/top/Default for Intro to CS</text>  </category>  <info format="moodle_auto_format"> <text>The default category for questions shared in context \'Intro to CS\'.</text></info><idnumber></idnumber></question><question type="multichoice"><name><text>Question 1</text></name><questiontext format="html"><text>Which of the following American presidents is credited with leading the country through the Great Depression and World War II?</text></questiontext><answer fraction="100"><text>Franklin D. Roosevelt</text><feedback><text>Correct FDR led the country through the Great Depression and World War II.</text></feedback></answer><answer fraction="0"><text>Theodore Roosevelt</text><feedback><text>Incorrect. While Theodore Roosevelt was a    significant president, he did not lead the country through the Great Depression and World War II.</text></feedback></answer><answer fraction="0"><text>Herbert Hoover</text><feedback><text>Incorrect. Herbert Hoover was president during the onset of the Great Depression, but did not lead the country through it or World War II.</text></feedback></answer><answer fraction="0"><text>Harry S. Truman</text><feedback><text>Incorrect. While Harry S. Truman was president during World War II, he did not lead the country through the Great Depression.</text></feedback></answer></question><question type="multichoice"><name><text>Question 2</text></name><questiontext format="html"><text>The American Civil War was fought primarily over which issue?</text></questiontext><answer fraction="100"><text>Slavery</text><feedback><text>Correct The American Civil War was fought primarily over the issue of slavery.</text></feedback></answer><answer fraction="0"><text>States\' rights</text><feedback><text>Incorrect. While states\' rights were an issue, the primary cause of the American Civil War was slavery.</text></feedback></answer><answer fraction="0"><text>Economic disagreements</text><feedback><text>Incorrect. Economic disagreements were not the primary cause of the American Civil War.</text></feedback></answer><answer fraction="0"><text>Foreign policy</text><feedback><text>Incorrect. Foreign policy was not the primary cause of the American Civil War.</text></feedback></answer></question></quiz>';
      String xml3 = '<?xml version="1.0" encoding="UTF-8"?> <quiz> <question type="category"> <category> <text>\$course\$/top/Default</text>  </category> </question> <question type="essay"> <name> <text>moodle_api_test Test Import Question</text> </name> <questiontext format="html"> <text><![CDATA[<p>This is a test to import a question.</p>]]></text> </questiontext> <generalfeedback format="html"> <text></text> </generalfeedback> <defaultgrade>1</defaultgrade> <penalty>0</penalty> <hidden>0</hidden> <idnumber></idnumber> <responseformat>editorfilepicker</responseformat> <responserequired>1</responserequired> <responsefieldlines>10</responsefieldlines> <minwordlimit></minwordlimit> <maxwordlimit></maxwordlimit> <attachments>1</attachments> <attachmentsrequired>1</attachmentsrequired> <maxbytes>1048576</maxbytes> <filetypeslist></filetypeslist> <graderinfo format="html"> <text><![CDATA[<p>Information for Graders is shown here.</p>]]></text> </graderinfo> <responsetemplate format="html"> <text></text> </responsetemplate> </question> </quiz>';
      await moodleApi.importQuiz(courseId, xml3);
      print('Questions successfully imported!');
    } catch (e) {
      print(e);
    }
  }
}