# Quiz Generator #

Allows importing and exporting of Moodle questions through web service functions.  Currently only supports Moodle XML format.

<u>New web service functions</u>

<b>local_quizgen_export_questions</b>

- Exports questions in Moodle XML format given their question IDs.
- Example: http://100.25.213.47/webservice/rest/server.php?wstoken=TOKEN&wsfunction=local_quizgen_export_questions&questions[0][questionid]=2&questions[1][questionid]=3&questions[2][questionid]=4
  - Note: replace TOKEN with a valid auth token

<b>local_quizgen_import_questions</b>

- Imports questions in XML format to the given course.
- Example: http://100.25.213.47/webservice/rest/server.php?wstoken=TOKEN&wsfunction=local_quizgen_import_questions&courseid=2&questionxml=<?xml version="1.0" encoding="UTF-8"?> <quiz> <question type="category"> <category> <text>$course$/top/Default for Intro to CS</text>  </category>  <info format="moodle_auto_format"> <text>The default category for questions shared in context 'Intro to CS'.</text></info><idnumber></idnumber></question> <question type="essay"> <name> <text>Test Import Question</text> </name> <questiontext format="html"> <text><![CDATA[<p>This is a test to import a question.</p>]]></text> </questiontext> <generalfeedback format="html"> <text></text> </generalfeedback> <defaultgrade>1</defaultgrade> <penalty>0</penalty> <hidden>0</hidden> <idnumber></idnumber> <responseformat>editorfilepicker</responseformat> <responserequired>1</responserequired> <responsefieldlines>10</responsefieldlines> <minwordlimit></minwordlimit> <maxwordlimit></maxwordlimit> <attachments>1</attachments> <attachmentsrequired>1</attachmentsrequired> <maxbytes>1048576</maxbytes> <filetypeslist></filetypeslist> <graderinfo format="html"> <text><![CDATA[<p>Information for Graders is shown here.</p>]]></text> </graderinfo> <responsetemplate format="html"> <text></text> </responsetemplate> </question> </quiz>
   - Note: replace TOKEN with a valid auth token

## Installing via uploaded ZIP file ##

1. Log in to your Moodle site as an admin and go to _Site administration >
   Plugins > Install plugins_.
2. Upload the ZIP file with the plugin code. You should only be prompted to add
   extra details if your plugin type is not automatically detected.
3. Check the plugin validation report and finish the installation.

## Installing manually ##

The plugin can be also installed by putting the contents of this directory to

    {your/moodle/dirroot}/local/quizgen

Afterwards, log in to your Moodle site as an admin and go to _Site administration >
Notifications_ to complete the installation.

Alternatively, you can run

    $ php admin/cli/upgrade.php

to complete the installation from the command line.

## License ##

2024 Tianming Zhu

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
