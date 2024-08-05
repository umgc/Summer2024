<?php
namespace local_quizgen\external;

/**
 * Class for external function export_questions.
 *
 * @package     local_quizgen
 * @category    string
 * @copyright   2024 Tianming Zhu
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

use core_external\external_api;
use core_external\external_function_parameters;
use core_external\external_multiple_structure;
use core_external\external_single_structure;
use core_external\external_value;
use qformat_xml;
use question_bank;

class export_questions extends external_api {

    /**
     * Defines function parameters
     * @return external_function_parameters
     */
    public static function execute_parameters() {
        return new external_function_parameters([
            'questions' => new external_multiple_structure(
                new external_single_structure([
                    'questionid' => new external_value(PARAM_INT, 'the question id'),
                ])
            )
        ]);
    }
	
	/**
     * Defines function return values
     * @return external_function_parameters
     */
	public static function execute_returns() {
		return new external_value(PARAM_RAW, 'Question XML');
	}

    /**
     * Execute the function.
     * @param $questions
     * @return string
     * @throws \invalid_parameter_exception
     * @throws \moodle_exception
     */
	public static function execute($questions) {
		global $CFG;
		require_once("$CFG->dirroot/lib/questionlib.php");
		require_once("$CFG->dirroot/question/format/xml/format.php");
		
        $params = self::validate_parameters(self::execute_parameters(), ['questions' => $questions]);

        $qdata = array();

        foreach ($params['questions'] as $question) {
            $question = (object)$question;

            // Load the necessary data.
            $questiondata = question_bank::load_question_data($question->questionid);

            // Check permissions.
            question_require_capability_on($questiondata, 'view');

            // Store data in array.
            $qdata[] = $questiondata;
        }

		// Set up the export format.
		$qformat = new qformat_xml();
		$qformat->setQuestions($qdata);
		$qformat->setCattofile(false);
		$qformat->setContexttofile(false);

		// Do the export.
		if (!$qformat->exportpreprocess()) {
			return 'exportpreprocess() failed';
		}
		if (!$content = $qformat->exportprocess()) {
			return 'exportprocess() failed';
		}
		return $content;
	}
}