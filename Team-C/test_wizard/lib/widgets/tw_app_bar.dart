import 'package:flutter/material.dart';

class TWAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String? assessment;
  final String? className;
  final String screenTitle;
  final bool implyLeading;
  late final Text? leadingWidget;

  TWAppBar({
    super.key,
    required this.context,
    this.assessment,
    this.className,
    required this.screenTitle,
    this.implyLeading = false,
  }) {
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
    } else {
      leadingWidget = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFF6600),
      foregroundColor: Colors.white,
      automaticallyImplyLeading: implyLeading,
      leading: implyLeading
          ? Tooltip(
              message: 'Back',
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      bottom: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0072BB),
        foregroundColor: Colors.white,
        title: Text(
          screenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kBottomNavigationBarHeight);
}
