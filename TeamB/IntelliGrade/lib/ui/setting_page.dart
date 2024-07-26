import 'package:flutter/material.dart';
import 'package:intelligrade/ui/header.dart';

class Setting extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const Setting({super.key, required this.themeModeNotifier});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: "Settings"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: widget.themeModeNotifier.value == ThemeMode.dark,
              onChanged: (bool value) {
                setState(() {
                  widget.themeModeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
