import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/views/teacher_dashboard_view.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';

class MoodleOAuth {
  static final OAuth2Client _client = OAuth2Client(
    authorizeUrl: 'https://testwizard2.moodlecloud.com/oauth2/authorize.php',
    tokenUrl: 'https://testwizard2.moodlecloud.com/oauth2/token.php',
    redirectUri: 'https://3.139.66.147/oauth2redirect', // Corrected URL
    customUriScheme: 'testwizard', // A placeholder scheme
  );

  static final OAuth2Helper _oauth2Helper = OAuth2Helper(
    _client,
    clientId: '5UTBZt1m1evhgdpENeciQ',
    clientSecret: 'VTQCdV7Xr28lbhP57KLmIPpmeM3x5iXNbDOEueW1RYKdI3iSaKlCUGz8RGp',
    scopes: ['openid', 'profile', 'email'],
  );

  static Future<void> login(BuildContext context) async {
    try {
      var token = await _oauth2Helper.getToken();
      if (token != null) {
        // Navigate to the Teacher Dashboard with logged-in status
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AssessmentProvider()),
                ChangeNotifierProvider(create: (_) => UserProvider()),
              ],
              child: TeacherDashboard(
                status: 'loggedIn',
                tests: [], // Pass the appropriate list of tests here
              ),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle error
      print('OAuth2 login error: $e');
    }
  }
}
