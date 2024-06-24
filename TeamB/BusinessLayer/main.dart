import 'app_launcher.dart';
import 'main_controller.dart';

void main() {
  AppLauncher appLauncher = AppLauncher();
  appLauncher.init();

  MainController mainController = MainController();
  mainController.createAssessment();
  mainController.viewAssessment();
  mainController.settings();
  mainController.gradeAssessment();
}
