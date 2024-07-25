import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  bool isLoggedInToMoodle;

  UserProvider({
    this.isLoggedInToMoodle = false,
  });
}
