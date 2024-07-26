import 'package:flutter/material.dart';
import 'package:test_wizard/utils/validators.dart';

class DropdownSelect extends StatefulWidget {
  final TextEditingController controller;
  final String dropdownTitle;
  final bool isDisabled;
  final List<Map<String, dynamic>> options;
  const DropdownSelect({
    super.key,
    required this.isDisabled,
    required this.controller,
    required this.dropdownTitle,
    required this.options,
  });

  @override
  State<DropdownSelect> createState() => DropdownSelectState();
}

class DropdownSelectState extends State<DropdownSelect> {
  Map<String, dynamic>? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: selectedValue,
      iconDisabledColor: Colors.grey[50],
      disabledHint: const Text('Disabled without Moodle'),
      onChanged: widget.isDisabled
          ? null
          : (Map<String, dynamic>? newValue) {
              setState(() {
                if (newValue != null) {
                  widget.controller.text = newValue['fullname'];
                  selectedValue = newValue;
                }
              });
            },
      items: widget.options.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: value,
          child: Text(value['fullname']),
        );
      }).toList(),
      validator: widget.isDisabled
          ? null
          : (Map<String, dynamic>? value) {
              if (value == null || value['fullname'] == 'Select Course') {
                return 'Please select a valid option';
              }
              return null;
            },
      decoration: InputDecoration(
        label: Text(widget.dropdownTitle),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
