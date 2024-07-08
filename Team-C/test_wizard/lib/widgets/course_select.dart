import 'package:flutter/material.dart';
import 'package:test_wizard/models/temp.dart';
import 'package:test_wizard/utils/validators.dart';

class CourseSelect extends StatefulWidget {
  final TextEditingController controller;
  const CourseSelect({super.key, required this.controller});

  @override
  State<CourseSelect> createState() => CourseSelectState();
}

class CourseSelectState extends State<CourseSelect> {
  late String selectedValue = 'Select Course';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: TempModel.fetchDropdownOptions(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                if (newValue != null) {
                  selectedValue = newValue;
                  widget.controller.text = newValue;
                }
              });
            },
            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: Validators.checkCourseHasBeenSelected,
            decoration: const InputDecoration(
              label: Text('Course'),
              border: OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
}
