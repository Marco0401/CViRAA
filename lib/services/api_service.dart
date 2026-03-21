import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your computer's local IP address
  // Find it by running 'ipconfig' in cmd and look for IPv4 Address
  static const String baseUrl = 'https://democat.depedcarcarcity.com/api';
  
  // Login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      // Check if response is valid JSON
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'message': 'Server error [${response.statusCode}]: "${response.body}"',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // Scan QR Code
  static Future<Map<String, dynamic>> scanQR(
    String participantID,
    String coachUsername,
    String checkpoint, {
    String? sportCategory,
    String? role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/scan_qr.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'participantID': participantID,
          'coach_username': coachUsername,
          'checkpoint': checkpoint,
          'sport_category': sportCategory,
          'role': role,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  // Get scanned athletes for today
  static Future<Map<String, dynamic>> getScannedAthletes(String coachUsername) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_scanned_athletes.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'coach_username': coachUsername,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}
