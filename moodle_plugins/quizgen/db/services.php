<?php
namespace local_quizgen\db;

/**
 * Defines web service functions.
 *
 * @package     local_quizgen
 * @category    string
 * @copyright   2024 Tianming Zhu
 * @license     https://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

$functions = [
    // Web service function name.
	'local_quizgen_export_questions' => [
        // The name of the namespaced class that the function is located in.
        'classname'   => 'local_quizgen\external\export_questions',

        // A brief, human-readable, description of the web service function.
        'description' => 'Export questions by question ID.',

        // Options include read, and write.
        'type'        => 'read',

        // Whether the service is available for use in AJAX calls from the web.
        'ajax'        => true,

        // An optional list of services where the function will be included.
        'services' => [
            MOODLE_OFFICIAL_MOBILE_SERVICE,
        ]
    ],

    // Web service function name.
    'local_quizgen_import_questions' => [
        // The name of the namespaced class that the function is located in.
        'classname'   => 'local_quizgen\external\import_questions',

        // A brief, human-readable, description of the web service function.
        'description' => 'Import questions in XML format.',

        // Options include read, and write.
        'type'        => 'write',

        // Whether the service is available for use in AJAX calls from the web.
        'ajax'        => true,

        // An optional list of services where the function will be included.
        'services' => [
            MOODLE_OFFICIAL_MOBILE_SERVICE,
        ]
    ],


    // XML String test.
    'local_quizgen_xml_string_test' => [
        // The name of the namespaced class that the function is located in.
        'classname'   => 'local_quizgen\external\xml_string_test',

        // A brief, human-readable, description of the web service function.
        'description' => 'Test XML string imports.',

        // Options include read, and write.
        'type'        => 'read',

        // Whether the service is available for use in AJAX calls from the web.
        'ajax'        => true,

        // An optional list of services where the function will be included.
        'services' => [
            MOODLE_OFFICIAL_MOBILE_SERVICE,
        ]
    ],
];