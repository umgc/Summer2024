import 'package:flutter/material.dart';

enum DataEditorType {
  question,
  answer,
}

class AssessmentDataEditor extends StatelessWidget {
  final DataEditorType editorType;
  final String text;
  const AssessmentDataEditor({
    super.key,
    required this.editorType,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(editorType == DataEditorType.question ? 'Question:' : 'Answer:'),
          const SizedBox(height: 5),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: text,
            ),
          ),
          const SizedBox(height: 5),
          IconRow(type: editorType),
        ],
      ),
    );
  }
}

class IconRow extends StatelessWidget {
  final DataEditorType type;
  const IconRow({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == DataEditorType.answer) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ],
      );
    }
  }
}
