import 'package:flutter/material.dart';

class CustomizedWidgets {
  static AppBar buildAppBar({
    required BuildContext context,
    String? assessment,
    String? className,
    bool implyLeading = false,
  }) {
    Text? leadingWidget;
    if ((assessment != null && className == null) ||
        (assessment == null && className != null)) {
      throw ArgumentError(
          "Assessment and Class Name must be assigned or not assigned together. ");
    } else if (assessment != null) {
      leadingWidget = Text(
        '$assessment, $className',
        style: const TextStyle(
          fontSize: 16.0,
        ),
      );
    }
    return AppBar(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: implyLeading,
      title: Row(
        children: [
          // Leading widget
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: leadingWidget,
          ),
          // Spacer to take up remaining space
          const Spacer(),
          // Title
          const Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'TestWizard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
