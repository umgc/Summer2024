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

use core_external\external_api;
use core_external\external_function_parameters;
use core_external\external_multiple_structure;
use core_external\external_single_structure;
use core_external\external_value;
use core_text;
use qformat_xml;

class xml_string_test extends external_api
{

    /**
     * Defines function parameters
     * @return external_function_parameters
     */
    public static function execute_parameters()
    {
        return new external_function_parameters([
            'xml' => new external_value(PARAM_RAW, 'XML String'),
        ]);
    }

    /**
     * Defines function return values
     * @return external_single_structure
     */
    public static function execute_returns()
    {
            return new external_single_structure([
                'xml' => new external_value(PARAM_RAW, 'the XML string'),
            ]);
    }

    /**
     * Execute the function.
     * @param $courseid
     * @param $questionxml
     * @return array
     * @throws \invalid_parameter_exception
     * @throws \moodle_exception
     */
    public static function execute($xml)
    {
        global $CFG;
        require_once("$CFG->dirroot/lib/questionlib.php");
        require_once("$CFG->dirroot/lib/datalib.php");
        require_once("$CFG->dirroot/question/format/xml/format.php");

        $params = self::validate_parameters(self::execute_parameters(), ['xml' => $xml]);

        // write XML data to temp file
        $tmpfile = tmpfile();
        if (!fwrite($tmpfile, $xml)) {
            return ['xml' => 'Failed to write to temp file'];
        }
        $metadata = stream_get_meta_data($tmpfile);
        $tmpfilename = $metadata['uri'];

        $array = self::readdata($tmpfilename);

        if ($array === false) {
            return ['xml' => 'Failed to read from temp file'];
        } else {
            return ['xml' => implode('', $array)];
        }

//        fseek($tmpfile, 0);
//        $read = fread($tmpfile, 4096);
//        if ($read === false) {
//            return ['xml' => 'Failed to read from temp file'];
//        } else {
//            return ['xml' => $read];
//        }

//        $retval = ['xml' => $xml];
//        return $retval;
    }

    public static function readdata($filename) {
        if (is_readable($filename)) {
            $filearray = file($filename);

            // If the first line of the file starts with a UTF-8 BOM, remove it.
            $filearray[0] = core_text::trim_utf8_bom($filearray[0]);

            // Check for Macintosh OS line returns (ie file on one line), and fix.
            if (preg_match("~\r~", $filearray[0]) AND !preg_match("~\n~", $filearray[0])) {
                return explode("\r", $filearray[0]);
            } else {
                return $filearray;
            }
        }
        return false;
    }
}