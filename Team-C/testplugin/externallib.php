<?php
namespace local_testplugin\external;

defined('MOODLE_INTERNAL') || die();

require_once($CFG->libdir . '/externallib.php');
require_once($CFG->dirroot . '/mod/quiz/lib.php');
require_once($CFG->dirroot . '/mod/quiz/locallib.php');
require_once($CFG->libdir . '/gradelib.php');
require_once($CFG->dirroot . '/question/editlib.php');
require_once($CFG->dirroot . '/question/engine/lib.php');
require_once($CFG->dirroot . '/question/lib.php');
require_once($CFG->dirroot . '/course/lib.php');
require_once($CFG->dirroot . '/course/modlib.php');
require_once($CFG->dirroot . '/mod/quiz/report/statistics/report.php');

use external_function_parameters;
use external_single_structure;
use external_multiple_structure;
use external_value;
use context_system;
use context_course;
use context_module;
use moodle_exception;
use coding_exception;
use required_capability_exception;
use access_manager;
use external_api;
use qformat_xml;
use question_bank;
use question_edit_contexts;

class create_quiz extends \external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'courseid' => new external_value(PARAM_INT, 'ID of the course'),
                'name' => new external_value(PARAM_TEXT, 'Name of the quiz'),
                'intro' => new external_value(PARAM_RAW, 'Introductory text for the quiz'),
            )
        );
    }

    public static function execute_returns(): external_single_structure {
        return new external_single_structure(
            array(
                'quizid' => new external_value(PARAM_INT, 'ID of the created quiz')
            )
        );
    }

    public static function execute($courseid, $name, $intro): array {
        global $DB, $USER;

        // validate params
        $params = self::validate_parameters(self::execute_parameters(), array(
            'courseid' => $courseid,
            'name' => $name,
            'intro' => $intro,
        ));

        // set context
        $context = context_course::instance($params['courseid']);

        // ensure the user has permission to create a quiz
        self::validate_context($context);
        require_capability('mod/quiz:addinstance', $context);
        require_capability('mod/quiz:manage', $context);

        // create the course module
        $module = new \stdClass();
        $module->course = $params['courseid'];
        $module->module = $DB->get_field('modules', 'id', array('name' => 'quiz'));
        $module->instance = 0;
        $module->section = 0; 
        $module->visible = 1;
        $module->visibleold = 1;
        $module->groupmode = 0;
        $module->groupingid = 0;
        $module->completion = 0;
        $module->idnumber = 1;
        $module->added = time();

        // add the course module
        $module->coursemodule = add_course_module($module);
        if (!$module->coursemodule) {
            throw new moodle_exception('Could not create course module');
        }

        // update module ID
        $module->id = $module->coursemodule;

        // add course module to section
        \course_add_cm_to_section($params['courseid'], $module->id, 0);

        // create the quiz module
        $quiz = new \stdClass();
        $quiz->course = $params['courseid'];
        $quiz->name = $params['name'];
        $quiz->intro = '<p>' . $params['intro'] . '</p>';
        $quiz->introformat = FORMAT_HTML;
        $quiz->timeopen = 0;
        $quiz->timeclose = 0;
        $quiz->preferredbehaviour = 'deferredfeedback';
        $quiz->attempts = 0;
        $quiz->grade = 0;
        $quiz->sumgrades = 0;
        $quiz->timelimit = 0;
        $quiz->overduehandling = 'autosubmit';
        $quiz->graceperiod = 0;
        $quiz->timecreated = time();
        $quiz->timemodified = time();
        $quiz->quizpassword = '';
        $quiz->coursemodule = $module->id;
        $quiz->feedbackboundarycount = 0;
        $quiz->feedbacktext = [];
        $quiz->questionsperpage = 1;
        $quiz->shuffleanswers = 1;
        $quiz->browsersecurity = '-';

        // process the options from the form.
        $result = quiz_process_options($quiz);
        if ($result && is_string($result)) {
            throw new moodle_exception($result);
        }

        // insert the quiz into the database
        $quiz->id = $DB->insert_record('quiz', $quiz);

        // update the course module with the quiz instance ID
        $DB->set_field('course_modules', 'instance', $quiz->id, array('id' => $module->id));

        // create the first section for this quiz.
        $DB->insert_record('quiz_sections', ['quizid' => $quiz->id, 'firstslot' => 1, 'heading' => '', 'shufflequestions' => 0]);

        // clear feedback
        $DB->delete_records('quiz_feedback', ['quizid' => $quiz->id]);

        // set feedback
        for ($i = 0; $i <= $quiz->feedbackboundarycount; $i++) {
            if (isset($quiz->feedbacktext[$i])) {
                $feedback = new \stdClass();
                $feedback->quizid = $quiz->id;
                $feedback->feedbacktext = $quiz->feedbacktext[$i]['text'] ?? '';
                $feedback->feedbacktextformat = $quiz->feedbacktext[$i]['format'] ?? FORMAT_HTML;
                $feedback->mingrade = $quiz->feedbackboundaries[$i] ?? 0;
                $feedback->maxgrade = $quiz->feedbackboundaries[$i - 1] ?? 100;
                $feedback->id = $DB->insert_record('quiz_feedback', $feedback);
                $feedbacktext = file_save_draft_area_files((int)$quiz->feedbacktext[$i]['itemid'] ?? 0,
                    $context->id, 'mod_quiz', 'feedback', $feedback->id,
                    ['subdirs' => false, 'maxfiles' => -1, 'maxbytes' => 0],
                    $quiz->feedbacktext[$i]['text'] ?? '');
                $DB->set_field('quiz_feedback', 'feedbacktext', $feedbacktext, ['id' => $feedback->id]);
            }
        }

        // store settings belonging to the access rules
        \mod_quiz\access_manager::save_settings($quiz);

        // update  events related to this quiz
        quiz_update_events($quiz);
        $completionexpected = (!empty($quiz->completionexpected)) ? $quiz->completionexpected : null;
        \core_completion\api::update_completion_date_event($quiz->coursemodule, 'quiz', $quiz->id, $completionexpected);

        // update related grade item.
        quiz_grade_item_update($quiz);

        // update quiz review fields
        $quiz->reviewattempt = 69888;
        $quiz->reviewcorrectness = 4352;
        $quiz->reviewmaxmarks = 69888;
        $quiz->reviewmarks = 4352;
        $quiz->reviewspecificfeedback = 4352;
        $quiz->reviewgeneralfeedback = 4352;
        $quiz->reviewrightanswer = 4352;
        $quiz->reviewoverallfeedback = 4352;
        $DB->update_record('quiz', $quiz);

        // return quiz ID
        return array('quizid' => $quiz->id);
    }
};

class add_question_to_quiz extends \external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'quizid' => new external_value(PARAM_INT, 'ID of the quiz'),
                'questionid' => new external_value(PARAM_INT, 'ID of the question'),
            )
        );
    }

    public static function execute_returns(): external_single_structure {
        return new external_single_structure(
            array(
                'questionid' => new external_value(PARAM_INT, 'ID of the created question')
            )
        );
    }

    public static function execute($quizid, $questionid): array {
        global $DB, $USER;

        // check if the quiz exists.
        if (!$quiz = $DB->get_record('quiz', array('id' => $quizid))) {
            throw new moodle_exception('invalidquizid', 'error');
        }

        // add question to quiz
        quiz_add_quiz_question($questionid, $quiz, $page = 0, $maxmark = null);

        // return question id
        return array('questionid' => $questionid);
    }
};

class delete_quiz extends \external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'quizid' => new external_value(PARAM_INT, 'ID of the quiz to delete')
            )
        );
    }

    public static function execute_returns(): external_single_structure {
        return new external_single_structure(
            array(
                'status' => new external_value(PARAM_BOOL, 'Status of the quiz deletion')
            )
        );
    }

    public static function execute($quizid): array {
        global $DB, $CFG;
        require_once($CFG->dirroot . '/course/lib.php');
        
        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), array(
            'quizid' => $quizid
        ));

        // check if quiz exists
        if (!$quiz = $DB->get_record('quiz', array('id' => $params['quizid']))) {
            throw new moodle_exception('Quiz not found');
        }

        // retrieve course module ID
        $module_id = $DB->get_field('modules', 'id', array('name' => 'quiz'));
        if (!$cm = $DB->get_record('course_modules', array('module' => $module_id, 'instance' => $quiz->id))) {
            throw new moodle_exception('Invalid course module ID');
        }

        // delete the course module
        course_delete_module($cm->id);

        // check if quiz exists
        if (!$quiz = $DB->get_record('quiz', array('id' => $params['quizid']))) {
            // return true status
            return array('status' => true);

        } else {
            // return false status
            return array('status' => false);
        }        
    }
};

class export_quiz_questions extends external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'quizid' => new external_value(PARAM_INT, 'ID of the quiz')
            )
        );
    }

    public static function execute_returns() {
        return new external_value(PARAM_RAW, 'Question XML');
    }

    public static function execute($quizid) {
        global $CFG, $DB;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), array(
            'quizid' => $quizid
        ));

        // // check if quiz exists
        // if (!$quiz = $DB->get_record('quiz', array('id' => $params['quizid']))) {
        //     throw new moodle_exception('Quiz not found');
        // }
        // check if quiz exists
        $quiz = $DB->get_record('quiz', array('id' => $params['quizid']));
        if ($quiz == null) {
            throw new moodle_exception('Quiz not found');
        }

        // get questions from quiz
        // $questions = $DB->get_records('quiz_slots', ['quizid' => $params['quizid']], '', 'id');
        $questions = $DB->get_records('quiz_slots', ['quizid' => 11], '', 'id');
        
        // check if questions exist
        if ($questions == null) {
            throw new moodle_exception('No questions found');
        }

        // format the result as an array of question IDs
        $results = [];
        foreach ($questions as $question) {
            $results[] = ['questionid' => $question->id];
        }

        // create array to store question data
        $qdata = [];

        // loop through quiz questions
        foreach ($results as $result) {
            try {
                // load the question data
                $questiondata = question_bank::load_question_data($result['questionid']);

                // check permissions
                question_require_capability_on($questiondata, 'view');

                // store data
                $qdata[] = $questiondata;
                
            } catch (Exception $e) {
                // handle exceptions
                debugging('Error loading question data: ' . $e->getMessage(), DEBUG_DEVELOPER);
                throw new moodle_exception('errorloadingquestion', 'local_testplugin', '', null, $e->getMessage());
            }
        }

        // set export format
        $qformat = new qformat_xml();
        $qformat->setQuestions($qdata);
        $qformat->setCattofile(false);
        $qformat->setContexttofile(false);

        // export data
        if (!$qformat->exportpreprocess()) {
            return 'exportpreprocess() failed';
        }
        if (!$content = $qformat->exportprocess()) {
            return 'exportprocess() failed';
        }

        // return data
        return $content;
    }
};

class export_questions extends external_api {

    public static function execute_parameters() {
        return new external_function_parameters([
            'questions' => new external_multiple_structure(
                new external_single_structure([
                    'questionid' => new external_value(PARAM_INT, 'the question id'),
                ])
            )
        ]);
    }

    public static function execute_returns() {
        return new external_value(PARAM_RAW, 'Question XML');
    }

    public static function execute($questions) {
        global $CFG;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), ['questions' => $questions]);

        // create array
        $qdata = array();

        foreach ($params['questions'] as $question) {
            $question = (object)$question;

            try {
                // load the question data
                $questiondata = question_bank::load_question_data($question->questionid);

                // check permissions
                question_require_capability_on($questiondata, 'view');

                // store data
                $qdata[] = $questiondata;
            } catch (Exception $e) {
                // handle exceptions
                debugging('Error loading question data: ' . $e->getMessage(), DEBUG_DEVELOPER);
                throw new moodle_exception('errorloadingquestion', 'local_testplugin', '', null, $e->getMessage());
            }
        }

        // set export format.
        $qformat = new qformat_xml();
        $qformat->setQuestions($qdata);
        $qformat->setCattofile(false);
        $qformat->setContexttofile(false);

        // export data
        if (!$qformat->exportpreprocess()) {
            return 'exportpreprocess() failed';
        }
        if (!$content = $qformat->exportprocess()) {
            return 'exportprocess() failed';
        }

        // set content type to XML
        header('Content-Type: application/xml; charset=utf-8');

        // return data
        return $content;
    }
};

class import_questions_xml extends \external_api {

    public static function execute_parameters() {
        return new external_function_parameters([
            'questionxml' => new external_value(PARAM_RAW, 'Question XML'),
        ]);
    }

    public static function execute_returns() {
        return new external_multiple_structure(
            new external_single_structure([
                'questionid' => new external_value(PARAM_INT, 'The question ID'),
            ])
        );
    }

    public static function execute($questionxml) {
        global $CFG;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/lib/datalib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        // set default home course
        $courseid = 1;

        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), [
            'questionxml' => $questionxml,
        ]);

        // create temp file for XML data
        $tempdir = make_request_directory();
        $tempfile = tempnam($tempdir, 'questionxml_');
        file_put_contents($tempfile, $questionxml);

        // set up import formatter
        $qformat = new qformat_xml();
        $qformat->setContexts((new question_edit_contexts(context_course::instance($courseid)))->all());
        $qformat->setCourse(get_course($courseid));
        $qformat->setFilename($tempfile);
        $qformat->setMatchgrades('error');
        $qformat->setCatfromfile(1);
        $qformat->setContextfromfile(1);
        $qformat->setStoponerror(1);
        $qformat->setCattofile(1);
        $qformat->setContexttofile(1);
        $qformat->set_display_progress(false);

        // import data
        try {
            $imported = $qformat->importprocess();
        } catch (Exception $e) {
            throw new moodle_exception('importerror', 'local_testplugin', '', $e->getMessage());
        } finally {
            // clean up temporary file
            if (file_exists($tempfile)) {
                unlink($tempfile);
            }
        }

        // set list of question IDs
        $retval = [];
        foreach ($qformat->questionids as $questionid) {
            $retval[] = ['questionid' => $questionid];
        }

        // return question ids
        return $retval;
    }
};

class import_questions_json extends \external_api {

    public static function execute_parameters() {
        return new external_function_parameters([
            'questionjson' => new external_value(PARAM_RAW, 'Question JSON'),
        ]);
    }
    
    public static function execute_returns() {
        return new external_multiple_structure(
            new external_single_structure([
                'questionid' => new external_value(PARAM_INT, 'The question ID'),
            ])
        );
    }

    public static function execute($questionjson) {
        global $CFG, $DB;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/lib/datalib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        // Set default home course
        $courseid = 1;

        // Validate parameters
        $params = self::validate_parameters(self::execute_parameters(), [
            'questionjson' => $questionjson,
        ]);

        // Decode JSON to PHP array
        $questionArray = json_decode($questionjson, true);        

        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new invalid_parameter_exception('Invalid JSON: ' . json_last_error_msg());
        }

        // Convert PHP array to XML
        $questionxml = self::convertArrayToXml($questionArray['quiz']);

        // Log the generated XML for debugging
        debugging("Generated XML: $questionxml", DEBUG_DEVELOPER);    

        // Create temp file for XML data
        $tempdir = make_request_directory();
        $tempfile = tempnam($tempdir, 'questionxml_');
        file_put_contents($tempfile, $questionxml);

        // Set up import formatter
        $qformat = new \qformat_xml();
        $qformat->setContexts((new question_edit_contexts(context_course::instance($courseid)))->all());
        $qformat->setCourse(get_course($courseid));
        $qformat->setFilename($tempfile);
        $qformat->setMatchgrades('error');
        $qformat->setCatfromfile(1);
        $qformat->setContextfromfile(1);
        $qformat->setStoponerror(1);
        $qformat->setCattofile(1);
        $qformat->setContexttofile(1);
        $qformat->set_display_progress(false);

        // Import data
        try {
            $imported = $qformat->importprocess();
        } catch (Exception $e) {
            // Log the error for debugging
            debugging("Import error: " . $e->getMessage(), DEBUG_DEVELOPER);
            throw new moodle_exception('importerror', 'local_testplugin', '', $e->getMessage());
        } finally {
            // Clean up temporary file
            if (file_exists($tempfile)) {
                unlink($tempfile);
            }
        }

        // Set list of question IDs
        $retval = [];
        foreach ($qformat->questionids as $questionid) {
            $retval[] = ['questionid' => $questionid];
        }

        return $retval;
    }

    private static function convertArrayToXml($array) {
        $xml = new \SimpleXMLElement('<quiz/>');
        self::arrayToXml($array, $xml);
        $dom = dom_import_simplexml($xml)->ownerDocument;
        $dom->formatOutput = true;
        return $dom->saveXML($dom->documentElement);
    }

    private static function arrayToXml($array, &$xml) {
        foreach ($array as $key => $value) {
            if (is_int($key)) {
                $key = "e";
            }
            if (is_array($value)) {
                if (self::isAssociativeArray($value)) {
                    if ($key == "question" && isset($value['type'])) {
                        $child = $xml->addChild($key);
                        $child->addAttribute('type', $value['type']);
                        unset($value['type']);
                    } else {
                        $child = $xml->addChild($key);
                    }
                    self::arrayToXml($value, $child);
                } else {
                    foreach ($value as $subValue) {
                        $child = $xml->addChild($key);
                        self::arrayToXml($subValue, $child);
                    }
                }
            } else {
                if ($key === 'text' && strpos($value, '<') !== false) {
                    $child = $xml->addChild($key);
                    $node = dom_import_simplexml($child);
                    $no = $node->ownerDocument;
                    $node->appendChild($no->createCDATASection($value));
                } elseif ($key === 'format') {
                    $xml->addAttribute('format', $value);
                } elseif ($key === 'fraction') {
                    $xml->addAttribute('fraction', $value);
                } elseif ($key === 'type') {
                    $xml->addAttribute('type', $value);
                } else {
                    $xml->addChild($key, htmlspecialchars($value));
                }
            }
        }
    }

    private static function isAssociativeArray(array $array) {
        return array_keys($array) !== range(0, count($array) - 1);
    }
}

class delete_questions extends \external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'quizid' => new external_value(PARAM_INT, 'ID of the quiz'),
                'questionids' => new external_multiple_structure(
                    new external_single_structure(
                        array(
                            'questionid' => new external_value(PARAM_INT, 'ID of the question')
                        )
                    ),
                    'IDs of multiple questions',
                    VALUE_REQUIRED
                )
            )
        );
    }

    public static function execute_returns(): external_single_structure {
        return new external_single_structure(
            array(
                'status' => new external_value(PARAM_BOOL, 'Status of the quiz deletion'),
                'num_questions' => new external_value(PARAM_INT, 'Number of questions deleted')
            )
        );
    }

    public static function execute($quizid, $questionids) {
        global $CFG, $DB;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), array(
            'quizid' => $quizid,
            'questionids' => $questionids
        ));

        // check if quiz exists
        if (!$quiz = $DB->get_record('quiz', array('id' => $params['quizid']))) {
            throw new moodle_exception('Quiz not found');
        }

        // get questions from quiz
        $questions = $DB->get_records('quiz_slots', ['quizid' => $params['quizid']], '', 'id');

        // check if questions exist
        if ($questions == null) {
            throw new moodle_exception('No questions found');
        }

        // set results as an array of question IDs that exist in the quiz
        $results = [];
        foreach ($params['questionids'] as $question) {
            $questionid = $question['questionid'];
            if (isset($questions[$questionid])) {
                $results[] = ['questionid' => $questionid];
                $DB->delete_records('quiz_slots', array('quizid' => $params['quizid'], 'id' => $questionid));
            }
        }   

        // update the quiz after removing questions
        require_once($CFG->dirroot . '/mod/quiz/locallib.php');
        \quiz_update_sumgrades($quiz);
        
        // return status and number of questions in results
        return array(
            'status' => true,
            'num_questions' => count($results)
        );
    }
};

class delete_qb_questions extends \external_api {

    public static function execute_parameters(): external_function_parameters {
        return new external_function_parameters(
            array(
                'questionids' => new external_multiple_structure(
                    new external_single_structure(
                        array(
                            'questionid' => new external_value(PARAM_INT, 'ID of the question')
                        )
                    ),
                    'IDs of multiple questions',
                    VALUE_REQUIRED
                )
            )
        );
    }

    public static function execute_returns(): external_single_structure {
        return new external_single_structure(
            array(
                'status' => new external_value(PARAM_BOOL, 'Status of the question deletion'),
                'num_questions' => new external_value(PARAM_INT, 'Number of questions deleted')
            )
        );
    }

    public static function execute($questionids) {
        global $CFG, $DB;

        // validate parameters
        $params = self::validate_parameters(self::execute_parameters(), array(
            'questionids' => $questionids
        ));

        // set status
        $status = true;

        // set context
        $context = \context_system::instance();
        self::validate_context($context);

        // create array
        $results = array();

        // loop thru questions
        foreach ($params['questionids'] as $question) {
            $questionid = $question['questionid'];

            // load the question data
            if (!$questiondata = question_bank::load_question_data($questionid)) {
                throw new moodle_exception('Question ' . $questionid . ' not found');
            }

            // delete questions
            try {
                question_delete_question($questionid);
                $results[] = $questionid;

            } catch (\Exception $e) {
                // set status
                $status = false;
                throw new moodle_exception('deleteerror', 'local_testplugin', '', $e->getMessage());
            }
        }

        // return status and number of questions in results
        return array(
            'status' => $status,
            'num_questions' => count($results)
        );
    }
};
?>
