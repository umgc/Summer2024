// test class for conversion between bean objects and XML.

import 'package:intelligrade/controller/model/beans.dart';
import 'package:intelligrade/controller/model/xml_converter.dart';

void main() {
  String xml = '<?xml version="1.0" encoding="UTF-8"?> <quiz>   <question type="multichoice">     <name>       <text>Basic Data Types</text>     </name>     <questiontext format="html">       <text><![CDATA[Which of the following is NOT a basic data type in most programming languages?]]></text>     </questiontext>     <answer fraction="0">       <text>Integer</text>     </answer>     <answer fraction="0">       <text>Float</text>     </answer>     <answer fraction="100">       <text>Table</text>     </answer>     <answer fraction="0">       <text>Boolean</text>     </answer>   </question>     <question type="truefalse">     <name>       <text>Algorithm Efficiency</text>     </name>     <questiontext format="html">       <text><![CDATA[An algorithm with O(n^2) time complexity is generally more efficient than an algorithm with O(n) time complexity for large inputs.]]></text>     </questiontext>     <answer fraction="0">       <text>True</text>     </answer>     <answer fraction="100">       <text>False</text>     </answer>   </question>     <question type="shortanswer">     <name>       <text>Programming Paradigm</text>     </name>     <questiontext format="html">       <text><![CDATA[What programming paradigm emphasizes the use of objects, classes, and inheritance?]]></text>     </questiontext>     <answer fraction="100">       <text>Object-Oriented Programming</text>     </answer>     <answer fraction="100">       <text>OOP</text>     </answer>   </question>     <question type="essay">     <name>       <text>Importance of Data Structures</text>     </name>     <questiontext format="html">       <text><![CDATA[Explain the importance of data structures in computer science. Discuss at least three different data structures and provide examples of when they might be used in real-world applications.]]></text>     </questiontext>   </question>     <question type="coderunner">     <name>       <text>Simple Function Implementation</text>     </name>     <questiontext format="html">       <text><![CDATA[Write a function in Python that takes a list of numbers as input and returns the sum of all even numbers in the list.]]></text>     </questiontext>     <answer>       <text> def sum_even_numbers(numbers):     return sum(num for num in numbers if num % 2 == 0)       </text>     </answer>   </question> </quiz>';

  print('XML to Object:');
  print('-----------------');
  Quiz quiz = Quiz.fromXmlString(xml);
  print(quiz);

  print('\nObject to XML:');
  print('-----------------');
  print(XmlConverter.convertQuizToXml(quiz).toXmlString(pretty: true));
}