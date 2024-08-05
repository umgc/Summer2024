import 'package:intelligrade/controller/model/beans.dart';

class PromptEngine {
  static const prompt_quizgen_choice =
      'Generate a multiple choice quiz in XML format '
      'that is compatible with Moodle XML import.  The quiz is to be on the subject of '
      '[subject] and should be related to [topic]. '
      'The quiz should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  The quiz should have [numquestions] questions. ';

  static const prompt_quizgen_truefalse =
      'Generate a true/false quiz in XML format '
      'that is compatible with Moodle XML import.  The quiz is to be on the subject of '
      '[subject] and should be related to [topic]. '
      'The quiz should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  The quiz should have [numquestions] questions. ';

  static const prompt_quizgen_shortanswer =
      'Generate a short answer assignment in XML '
      'format that is compatible with Moodle XML import.  The assignment is to be on the '
      'subject of [subject] and should be related to [topic]. '
      'The assignment should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language. The assignment should have [numquestions] questions.  ';

  static const prompt_quizgen_essay =
      'Generate an essay assignment in XML format that '
      'is compatible with Moodle XML import. The assignment is to be on the subject of [subject] '
      'and should be related to [topic]. '
      'The assignment should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  ';

  // static const prompt_quizgen_code =
  //     'Generate [numassignments] coding assignments in XML format '
  //     'that is compatible with Moodle XML import.  The assignments are to be on the subject of '
  //     '[subject], should be related to [topic], and the programming language should be [codinglanguage]. '
  //     'The assignments should be the same level of difficulty for college [gradelevel] '
  //     'students of the English-speaking language.  Be specific about [rubriccriteria]. The assignments '
  //     'are worth [maxgrade] points. Make a rubric to assess on later.  The question type should be essay. '
  //     'Create test dataset that will be used to test the application.  Create the expected results for '
  //     'each assignment when ran against test dataset.  ';

  static const prompt_quizgen_code =
      'Generate [numquestions] coding assignments in XML format '
      'that is compatible with Moodle XML import.  The assignments are to be on the subject of '
      '[subject], should be related to [topic], and the programming language should be [codinglanguage]. '
      'The assignments should be the same level of difficulty for college [gradelevel] '
      'students of the English-speaking language.  '
      'The question type should be essay.  '
      // 'Be specific about [rubriccriteria].  '
      // 'The assignments are worth [maxgrade] points. '
      'Make a rubric in the <generalfeedback> tag. '
      'Create a code template in the <responsetemplate> tag. '
      'Create a unit test to run the code template in the <graderinfo> tag. ';

  static const prompt_quizgen_xmlonly =
      'Provide only the XML in your response.  ';

  static const prompt_quizgen_choice_example =
      'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?> <quiz> <question type="multichoice"> <name> <text>Question 1</text> </name> <questiontext format="html"> <text>What does CPU stand for?</text> </questiontext> <answer fraction="100"> <text>Central Processing Unit</text> <feedback> <text>Correct! The CPU is the primary component of a computer that processes instructions.</text> </feedback> </answer> <answer fraction="0"> <text>Computer Processing Unit</text> <feedback> <text>Incorrect. While close, this is not the correct term.</text> </feedback> </answer> <answer fraction="0"> <text>Central Program Unit</text> <feedback> <text>Incorrect. This is not the correct term for CPU.</text> </feedback> </answer> <answer fraction="0"> <text>Control Processing Unit</text> <feedback> <text>Incorrect. While the CPU does involve processing, this is not the correct term.</text> </feedback> </answer> </question> <question type="multichoice"> <name> <text>Question 2</text> </name> <questiontext format="html"> <text>Which of the following is not a programming paradigm?</text> </questiontext> <answer fraction="0"> <text>Object-Oriented Programming</text> <feedback> <text>Incorrect. Object-Oriented Programming is a valid programming paradigm.</text> </feedback> </answer> <answer fraction="0"> <text>Functional Programming</text> <feedback> <text>Incorrect. Functional Programming is a valid programming paradigm.</text> </feedback> </answer> <answer fraction="100"> <text>Quantum Programming</text> <feedback> <text>Correct! While quantum computing exists, "Quantum Programming" is not a standard programming paradigm.</text> </feedback> </answer> <answer fraction="0"> <text>Procedural Programming</text> <feedback> <text>Incorrect. Procedural Programming is a valid programming paradigm.</text> </feedback> </answer> </question> <question type="multichoice"> <name> <text>Question 3</text> </name> <questiontext format="html"> <text>What is the primary function of an operating system?</text> </questiontext> <answer fraction="100"> <text>Manage computer hardware and software resources</text> <feedback> <text>Correct! The operating system acts as an intermediary between programs and the computer hardware.</text> </feedback> </answer> <answer fraction="0"> <text>Create documents and spreadsheets</text> <feedback> <text>Incorrect. This is the function of application software, not the operating system.</text> </feedback> </answer> <answer fraction="0"> <text>Browse the internet</text> <feedback> <text>Incorrect. Web browsing is a function of web browser applications, not the operating system itself.</text> </feedback> </answer> <answer fraction="0"> <text>Play video games</text> <feedback> <text>Incorrect. Playing games is a function of game software, not the primary function of an operating system.</text> </feedback> </answer> </question> <question type="multichoice"> <name> <text>Question 4</text> </name> <questiontext format="html"> <text>Which of the following is an example of a high-level programming language?</text> </questiontext> <answer fraction="0"> <text>Assembly</text> <feedback> <text>Incorrect. Assembly is a low-level programming language.</text> </feedback> </answer> <answer fraction="0"> <text>Machine Code</text> <feedback> <text>Incorrect. Machine code is the lowest-level programming language.</text> </feedback> </answer> <answer fraction="100"> <text>Python</text> <feedback> <text>Correct! Python is an example of a high-level programming language.</text> </feedback> </answer> <answer fraction="0"> <text>Binary</text> <feedback> <text>Incorrect. Binary is not a programming language, but a number system used in computing.</text> </feedback> </answer> </question> <question type="multichoice"> <name> <text>Question 5</text> </name> <questiontext format="html"> <text>What does HTML stand for?</text> </questiontext> <answer fraction="100"> <text>Hypertext Markup Language</text> <feedback> <text>Correct! HTML is used to structure content on the web.</text> </feedback> </answer> <answer fraction="0"> <text>Hyperlinks and Text Markup Language</text> <feedback> <text>Incorrect. While HTML does involve hyperlinks, this is not the correct expansion of the acronym.</text> </feedback> </answer> <answer fraction="0"> <text>Home Tool Markup Language</text> <feedback> <text>Incorrect. This is not what HTML stands for.</text> </feedback> </answer> <answer fraction="0"> <text>Hyper Transfer Markup Language</text> <feedback> <text>Incorrect. This is not the correct expansion of HTML.</text> </feedback> </answer> </question> </quiz>  ';
  static const prompt_quizgen_truefalse_example =
      'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?><quiz><question type="truefalse"><name><text>World War 2 Question 1</text></name><questiontext format="html"><text>The Normandy landings, also known as D-Day, took place on June 6, 1944.</text></questiontext><answer fraction="100"><text>True</text><feedback><text>Correct! The Normandy landings, codenamed Operation Neptune, indeed took place on June 6, 1944, marking the beginning of the Allied invasion of Nazi-occupied Western Europe.</text></feedback></answer><answer fraction="0"><text>False</text><feedback><text>Incorrect. The Normandy landings, also known as D-Day, did occur on June 6, 1944. This date marks a crucial turning point in World War 2.</text></feedback></answer></question><question type="truefalse"><name><text>World War 2 Question 2</text></name><questiontext format="html"><text>The atomic bombs dropped on Hiroshima and Nagasaki were codenamed "Little Boy" and "Fat Man" respectively.</text></questiontext><answer fraction="100"><text>True</text><feedback><text>Correct! "Little Boy" was the codename for the bomb dropped on Hiroshima on August 6, 1945, while "Fat Man" was dropped on Nagasaki on August 9, 1945.</text></feedback></answer><answer fraction="0"><text>False</text><feedback><text>Incorrect. The atomic bombs were indeed codenamed "Little Boy" (Hiroshima) and "Fat Man" (Nagasaki). These were the only two nuclear weapons ever used in warfare.</text></feedback></answer></question><question type="truefalse"><name><text>World War 2 Question 3</text></name><questiontext format="html"><text>The Battle of Stalingrad ended with a decisive Soviet victory, marking a turning point on the Eastern Front.</text></questiontext><answer fraction="100"><text>True</text><feedback><text>Correct! The Battle of Stalingrad, which lasted from August 23, 1942, to February 2, 1943, ended in a decisive Soviet victory and is considered a major turning point in World War 2.</text></feedback></answer><answer fraction="0"><text>False</text><feedback><text>Incorrect. The Battle of Stalingrad did indeed end with a decisive Soviet victory, which marked a crucial turning point on the Eastern Front and in World War 2 as a whole.</text></feedback></answer></question></quiz>  ';
  static const prompt_quizgen_shortanswer_example =
      'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?><quiz><question type="shortanswer"><name><text>Combinatorics Question 1</text></name><questiontext><text>In how many ways can 5 distinct books be arranged on a shelf?</text></questiontext><answer fraction="100"><text>120</text></answer><answer fraction="100"><text>5!</text></answer></question><question type="shortanswer"><name><text>Combinatorics Question 2</text></name><questiontext><text>How many different 4-digit numbers can be formed using the digits 1, 2, 3, 4, 5, 6 if no digit can be repeated?</text></questiontext><answer fraction="100"><text>360</text></answer></question></quiz>  ';
  static const prompt_quizgen_essay_example =
      'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?> <quiz> <question type="essay"> <name> <text>American Revolution Essay</text> </name> <questiontext format="html"> <text><![CDATA[<p>Write a well-structured essay analyzing the key factors that led to the American Revolution and its long-term impact on the formation of the United States. Your essay should address the following points:</p> <ul> <li>Discuss at least three major events or policies that contributed to growing tensions between the American colonies and Great Britain in the decade leading up to 1776.</li> <li>Explain the significance of the Declaration of Independence, both as a philosophical document and as a catalyst for revolutionary action.</li> <li>Analyze the role of key figures such as George Washington, Thomas Jefferson, and Benjamin Franklin in shaping the course of the revolution.</li> <li>Evaluate the impact of the American Revolution on the political, social, and economic structures of the newly formed United States.</li> <li>Consider how the ideals of the American Revolution influenced later democratic movements both in the United States and around the world.</li> </ul> <p>Your essay should be approximately 1000-1200 words in length. Use specific historical examples to support your arguments, and be sure to cite any sources you use.</p>]]></text> </questiontext> <generalfeedback format="html"> <text>This essay requires you to demonstrate your understanding of the causes and consequences of the American Revolution, as well as your ability to analyze historical events and their significance.</text> </generalfeedback> <defaultgrade>100</defaultgrade> <penalty>0</penalty> <hidden>0</hidden> <responseformat>editor</responseformat> <responserequired>1</responserequired> <responsefieldlines>15</responsefieldlines> <attachments>0</attachments> <attachmentsrequired>0</attachmentsrequired> <graderinfo format="html"> <text><![CDATA[<p>Grading Criteria:</p> <ul> <li>Clear thesis statement and well-structured argument: 20 points</li> <li>Accurate discussion of pre-revolutionary events and policies: 20 points</li> <li>Insightful analysis of the Declaration of Independence: 15 points</li> <li>Thoughtful examination of key revolutionary figures: 15 points</li> <li>Comprehensive evaluation of the revolution\'s impact: 20 points</li> <li>Consideration of the revolution\'s broader influence: 10 points</li> <li>Use of specific historical examples and proper citations: 10 points</li> </ul>]]></text> </graderinfo> <responsetemplate></responsetemplate> </question> </quiz>  ';
  static const prompt_quizgen_coding_example =
  'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?> <quiz>   <question type="essay">     <name>       <text>Dart List Manipulation: Filtering Even Numbers</text>     </name>     <questiontext format="html">       <text><![CDATA[         <p>Write a Dart function called <code>filterEvenNumbers</code> that takes a list of integers as input and returns a new list containing only the even numbers from the input list. Your function should use the following signature:</p>         <pre> List<int> filterEvenNumbers(List<int> numbers)         </pre>         <p>Requirements:</p>         <ul>           <li>Use Dart\'s list methods to implement the filtering logic.</li>           <li>The original list should not be modified.</li>           <li>If the input list is empty, return an empty list.</li>           <li>Include comments to explain your code.</li>         </ul>         <p>Test your function with different input lists to ensure it works correctly.</p>       ]]></text>     </questiontext>     <generalfeedback format="html">       <text><![CDATA[Rubric goes here]]></text>     </generalfeedback>     <defaultgrade>100</defaultgrade>     <penalty>0</penalty>     <hidden>0</hidden>     <responseformat>editor</responseformat>     <responserequired>1</responserequired>     <responsefieldlines>30</responsefieldlines>     <attachments>0</attachments>     <attachmentsrequired>0</attachmentsrequired>     <graderinfo format="html">       <text><![CDATA[         <pre> void main() {   List<int> numbers1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];   List<int> result1 = filterEvenNumbers(numbers1);   print(\'Test 1: \$result1\'); // Expected: [2, 4, 6, 8, 10]   List<int> numbers2 = [1, 3, 5, 7, 9];   List<int> result2 = filterEvenNumbers(numbers2);   print(\'Test 2: \$result2\'); // Expected: []   List<int> numbers3 = [];   List<int> result3 = filterEvenNumbers(numbers3);   print(\'Test 3: \$result3\'); // Expected: [] } List<int> filterEvenNumbers(List<int> numbers) {   // Your implementation here }         </pre>       ]]></text>     </graderinfo>     <responsetemplate><![CDATA[ List<int> filterEvenNumbers(List<int> numbers) {   // Your code here } void main() {   // Test your function here }     ]]></responsetemplate>   </question> </quiz>';
      // 'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?><quiz><question type="essay"><name><text><![CDATA[ Name of assignment goes here ]]></text></name><questiontext format="html"><text><![CDATA[ Assignment description goes here ]]></text></questiontext><generalfeedback format="html"><text><![CDATA[ Assignment criteria goes here ]]></text></generalfeedback><defaultgrade>Maximum grade goes here</defaultgrade><penalty>0</penalty><hidden>0</hidden><responseformat>editorfilepicker</responseformat><responserequired>1</responserequired><responsefieldlines>15</responsefieldlines><attachments>0</attachments><attachmentsrequired>1</attachmentsrequired><rubric><rubric_criteria><criterion><description><text><![CDATA[ Criteria description goes here ]]></text></description><levels><level><score>Level 4, the highest criteria score goes here.</score><definition><text><![CDATA[ Level 4 criteria definition goes here ]]></text></definition></level><level><score>Level 3 criteria score goes here</score><definition><text><![CDATA[ Level 3 criteria definition goes here ]]></text></definition></level><level><score>Level 2 criteria score goes here</score><definition><text><![CDATA[ Level 2 criteria definition goes here ]]></text></definition></level><level><score>Level 1, the lowest criteria score goes here</score><definition><text><![CDATA[ Level 1 criteria definition goes here ]]></text></definition></level></levels></criterion></rubric_criteria></rubric></question></quiz><dataset><data><inputs><input>Input goes here</input></inputs><expectedoutput>Expected output goes here</expectedoutput></data></dataset> ';
  // 'Please use this XML sample as a template for your response: <?xml version="1.0" encoding="UTF-8"?><quiz><question type="essay"><name><text>Recursive Functions in Dart</text></name><questiontext format="html"><text>Implement a recursive function in Dart that calculates the nth Fibonacci number. The Fibonacci sequence is defined as follows: the first two numbers are 0 and 1, and each subsequent number is the sum of the two preceding ones. Your function should take an integer n as input and return the nth Fibonacci number. Additionally, explain the time complexity of your recursive solution and suggest how you might optimize it using memoization. Provide your code implementation and explanation below.</text></questiontext><generalfeedback format="html"><text>A well-implemented recursive Fibonacci function should correctly calculate the nth Fibonacci number. The explanation should discuss the exponential time complexity of the naive recursive solution and how memoization can improve it to linear time complexity.</text></generalfeedback><defaultgrade>10</defaultgrade><penalty>0</penalty><hidden>0</hidden><responseformat>editor</responseformat><responserequired>1</responserequired><responsefieldlines>15</responsefieldlines><attachments>0</attachments></question></quiz>';

  static String generatePrompt(AssignmentForm form) {
    String prompt;
    switch (form.questionType) {
      case QuestionType.multichoice:
        prompt = prompt_quizgen_choice + prompt_quizgen_choice_example;
        break;
      case QuestionType.truefalse:
        prompt = prompt_quizgen_truefalse + prompt_quizgen_truefalse_example;
        break;
      case QuestionType.shortanswer:
        prompt =
            prompt_quizgen_shortanswer + prompt_quizgen_shortanswer_example;
        break;
      case QuestionType.essay:
        prompt = prompt_quizgen_essay + prompt_quizgen_essay_example;
        break;
      case QuestionType.coding:
        prompt = prompt_quizgen_code + prompt_quizgen_coding_example;
        break;
    }
    prompt = prompt
        .replaceAll('[subject]', form.subject)
        .replaceAll('[topic]', form.topic)
        .replaceAll('[gradelevel]', form.gradeLevel)
        .replaceAll('[maxgrade]', form.maximumGrade.toString())
        .replaceAll('[numquestions]', form.questionCount.toString());

    if (form.assignmentCount != null) {
      prompt = prompt.replaceAll(
          '[numassignments]', form.assignmentCount.toString());
    }
    if (form.gradingCriteria != null) {
      prompt = prompt.replaceAll('[rubriccriteria]', form.gradingCriteria!);
    }
    if (form.codingLanguage != null) {
      prompt = prompt.replaceAll('[codinglanguage]', form.codingLanguage!);
    }
    prompt += prompt_quizgen_xmlonly;
    return prompt;
  }
}
