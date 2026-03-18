import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyUsername = 'username';
  static const _keyCoachName = 'coach_name';
  static const _keyProfileImage = 'profile_image';
  static const _keyIsLoggedIn = 'is_logged_in';

  // Save session after login
  static Future<void> saveSession({
    required String username,
    required String coachName,
    String? profileImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyCoachName, coachName);
    if (profileImagePath != null) {
      await prefs.setString(_keyProfileImage, profileImagePath);
    }
  }

  // Get session data
  static Future<Map<String, String?>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_keyUsername),
      'coachName': prefs.getString(_keyCoachName),
      'profileImagePath': prefs.getString(_keyProfileImage),
    };
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear session on logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
