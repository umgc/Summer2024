import 'package:flutter/material.dart';
import 'package:test_wizard/models/temp.dart';
import 'package:test_wizard/utils/validators.dart';

class DropdownSelect extends StatefulWidget {
  final TextEditingController controller;
  final String dropdownTitle;
  const DropdownSelect({
    super.key,
    required this.controller,
    required this.dropdownTitle,
  });

  @override
  State<DropdownSelect> createState() => DropdownSelectState();
}

class DropdownSelectState extends State<DropdownSelect> {
  late String selectedValue = 'Select ${widget.dropdownTitle}';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: TempModel.fetchDropdownOptions(widget.dropdownTitle),
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
            decoration: InputDecoration(
              label: Text(widget.dropdownTitle),
              border: const OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
}
