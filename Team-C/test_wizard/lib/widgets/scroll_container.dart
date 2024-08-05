import 'package:flutter/material.dart';

class ScrollContainer extends StatelessWidget {
  final Widget? child;
  final double width;
  const ScrollContainer({super.key, this.child, this.width = 1200});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height - kToolbarHeight * 2,
          ),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
