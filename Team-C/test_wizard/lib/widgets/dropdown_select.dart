import 'package:flutter/material.dart';
import 'package:test_wizard/models/temp.dart';
import 'package:test_wizard/utils/validators.dart';

class DropdownSelect extends StatefulWidget {
  final TextEditingController controller;
  final String dropdownTitle;
  final bool isDisabled;
  final Future<List<String>> Function(String) future;
  const DropdownSelect({
    super.key,
    required this.isDisabled,
    required this.controller,
    required this.dropdownTitle,
    this.future = TempModel.fetchDropdownOptions,
  });

  @override
  State<DropdownSelect> createState() => DropdownSelectState();
}

class DropdownSelectState extends State<DropdownSelect> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.future(widget.dropdownTitle),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return DropdownButtonFormField<String>(
            value: selectedValue,
            iconDisabledColor: Colors.grey[50],
            disabledHint: const Text('Disabled without Moodle'),
            onChanged: widget.isDisabled
                ? null
                : (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        widget.controller.text = newValue;
                        selectedValue = newValue;
                      }
                    });
                  },
            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: widget.isDisabled
                ? null
                : Validators.checkOptionHasBeenSelected,
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
