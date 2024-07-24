<?php

$functions = array(
    'local_testplugin_create_quiz' => array(
        'classname'   => 'local_testplugin\external\create_quiz',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Create a quiz in a specified course',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'mod/quiz:addinstance',
    ),
    'local_testplugin_add_question_to_quiz' => array(
        'classname'   => 'local_testplugin\external\add_question_to_quiz',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Add a question to a specified quiz',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'mod/quiz:manage',
    ),
    'local_testplugin_delete_quiz' => array(
        'classname'   => 'local_testplugin\external\delete_quiz',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Delete a specified quiz',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'mod/quiz:manage',
    ),
    'local_testplugin_export_quiz_questions' => array(
        'classname'   => 'local_testplugin\external\export_quiz_questions',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Export quiz questions to XML format',
        'type'        => 'read',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:view',
    ),
    'local_testplugin_export_questions' => array(
        'classname'   => 'local_testplugin\external\export_questions',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Export questions to XML format',
        'type'        => 'read',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:view',
    ),
    'local_testplugin_import_questions_xml' => array(
        'classname'   => 'local_testplugin\external\import_questions_xml',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Import questions from XML format',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:add',
    ),
    'local_testplugin_import_questions_json' => array(
        'classname'   => 'local_testplugin\external\import_questions_json',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Import questions from JSON format',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:add',
    ),
    'local_testplugin_delete_questions' => array(
        'classname'   => 'local_testplugin\external\delete_questions',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Delete questions from a specified quiz',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'mod/quiz:manage',
    ),
    'local_testplugin_delete_qb_questions' => array(
        'classname'   => 'local_testplugin\external\delete_qb_questions',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Delete questions from the question bank',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:manage',
    ),
    'local_testplugin_edit_questions' => array(
        'classname'   => 'local_testplugin\external\edit_questions',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Edit questions in the question bank',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'moodle/question:editall',
    ),
    'local_testplugin_create_groups' => array(
        'classname'   => 'local_testplugin\external\create_groups',
        'methodname'  => 'execute',
        'classpath'   => 'local/testplugin/externallib.php',
        'description' => 'Create groups in a specified course',
        'type'        => 'write',
        'ajax'        => true,
        'capabilities'=> 'moodle/course:managegroups',
    ),
);

$services = array(
    'Test Plugin Service' => array(
        'functions' => array(
            'local_testplugin_create_quiz',
            'local_testplugin_add_question_to_quiz',
            'local_testplugin_delete_quiz',
            'local_testplugin_export_quiz_questions',
            'local_testplugin_export_questions',
            'local_testplugin_import_questions_xml',
            'local_testplugin_import_questions_json',
            'local_testplugin_delete_questions',
            'local_testplugin_delete_qb_questions',
            'local_testplugin_edit_questions',
            'local_testplugin_create_groups',
        ),
        'restrictedusers' => 0,
        'enabled' => 1,
        'shortname' => 'testplugin_service',
    ),
);
?>
