import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // store onboarded status
  Future<void> onboardUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isOnboard', true);
  }

  // check if user onboarding status
  Future<bool?> isOnboarded() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool('isOnboard');
  }

  // Store user auth token
  Future<void> saveAuthToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('auth_token', token);
  }

  // retrieve the user auth token
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('auth_token');
  }

    // retrieve the user auth token
  Future<bool> removeAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('auth_token');
  }
}
