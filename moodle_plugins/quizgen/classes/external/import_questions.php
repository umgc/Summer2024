<?php
namespace local_quizgen\external;

/**
 * Class for external function import_questions.
 *
 * @package     local_quizgen
 * @category    string
 * @copyright   2024 Tianming Zhu
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

use context_course;
use core_external\external_api;
use core_external\external_function_parameters;
use core_external\external_multiple_structure;
use core_external\external_single_structure;
use core_external\external_value;
use core_question\local\bank\question_edit_contexts;
use qformat_xml;

class import_questions extends external_api {

    /**
     * Defines function parameters
     * @return external_function_parameters
     */
    public static function execute_parameters() {
        return new external_function_parameters([
            'courseid' => new external_value(PARAM_INT, 'The course ID'),
            'questionxml' => new external_value(PARAM_RAW, 'Question XML'),
        ]);
    }

    /**
     * Defines function return values
     * @return external_multiple_structure
     */
    public static function execute_returns() {
        return new external_multiple_structure(
            new external_single_structure([
                'questionid' => new external_value(PARAM_INT, 'the question id'),
            ])
        );
    }

    /**
     * Execute the function.
     * @param $courseid
     * @param $questionxml
     * @return array
     * @throws \invalid_parameter_exception
     * @throws \moodle_exception
     */
    public static function execute($courseid, $questionxml) {
        global $CFG;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/lib/datalib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        $params = self::validate_parameters(self::execute_parameters(), [
            'courseid' => $courseid,
            'questionxml' => $questionxml,
        ]);

        // write XML data to temp file
        $tmpfile = tmpfile();
        fwrite($tmpfile, $questionxml);
        $metadata = stream_get_meta_data($tmpfile);
        $tmpfilename = $metadata['uri'];

        // Set up the import formatter
        $qformat = new qformat_xml();
        $qformat->setContexts((new question_edit_contexts(context_course::instance($courseid)))->all());
        $qformat->setCourse(get_course($courseid));
        $qformat->setFilename($tmpfilename);
        $qformat->setMatchgrades('error');
        $qformat->setCatfromfile(1);
        $qformat->setContextfromfile(1);
        $qformat->setStoponerror(1);
        $qformat->setCattofile(1);
        $qformat->setContexttofile(1);
        $qformat->set_display_progress(false);

        // Do the import
        $imported = $qformat->importprocess();

        // Return list of question IDs
        $retval = array();
        for ($i = 0; $i < count($qformat->questionids); $i++) {
            $retval[$i] = ['questionid' => $qformat->questionids[$i]];
        }
        return $retval;
    }
}