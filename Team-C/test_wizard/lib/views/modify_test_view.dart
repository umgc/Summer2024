import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/qset.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';
import 'package:test_wizard/widgets/column_header.dart';
import 'package:test_wizard/widgets/deleted_questions.dart';
import 'package:test_wizard/widgets/edit_prompt.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ModifyTestView extends StatelessWidget {
  final Assessment assessment;
  final String screenTitle;
  final String assessmentId;
  final int assessmentIndex;
  final int assessmentSetIndex;

  ModifyTestView({
    super.key,
    required this.screenTitle,
    required this.assessmentId,
    required this.assessmentIndex,
    required this.assessmentSetIndex,
    required this.assessment
  });

  


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionAnswerProvider(),
      child: Scaffold(
        appBar: TWAppBar(context: context, screenTitle: screenTitle),
        backgroundColor: const Color(0xffe6f2ff),
        body: ScrollContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const ColumnHeaderRow(),
              QSet(assessmentId: assessmentId, assessmentIndex: assessmentIndex, assessmentSetIndex: assessmentSetIndex),
              ButtonContainer(assessmentIndex: assessmentIndex, assessmentSetIndex: assessmentSetIndex, assessment:assessment ),
              const EditPrompt(),
              const DeletedQuestions(),
            ],
          ),
        ),
      ),
    );
  }
}

class ColumnHeaderRow extends StatelessWidget {
  const ColumnHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: ColumnHeader(headerText: 'Question')),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(left: 24.0), // Adjust the padding as needed
            child: ColumnHeader(headerText: 'Answer'),
          ),
        ),
        //Expanded(child: ColumnHeader(headerText: 'Previous Question')),
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final Assessment assessment;
  final int assessmentIndex;
  final int assessmentSetIndex;
  const ButtonContainer({
    super.key,
    required this.assessmentIndex,
    required this.assessmentSetIndex,
    required this.assessment
  }
  );
  
  void _printQuestionsAndAnswers(BuildContext context) {
    final questions =
        Provider.of<QuestionAnswerProvider>(context, listen: false).questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: questions.map((qa) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Question: ${qa.questionText}'),
                  pw.Text('Answer: ${qa.answerText}'),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  void _printQuestionsOnly(BuildContext context) {
    final questions =
        Provider.of<QuestionAnswerProvider>(context, listen: false).questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: questions.map((qa) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Question: ${qa.questionText}'),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>( 
      builder: (context, assessmentProvider, child){
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: Wrap(
            alignment: WrapAlignment.end,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => _printQuestionsAndAnswers(context),
                child: const Text('Print'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _printQuestionsOnly(context),
                child: const Text('Print Questions Only'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: (){
                  assessmentProvider.updateAssessment(assessmentSetIndex, assessmentIndex, assessment);
                  assessmentProvider.saveAssessmentsToFile();
                }

                 ,
                child: const Text('Save'),
              ),
              const SizedBox(width: 10),
              const CancelButton(),
            ],
          ),
        );
      }
    );
  }
}
