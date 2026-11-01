
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  static int? currentUserId;
  static String? currentUserName;
  static String? currentUserEmail;
  static String? _sessionToken;

  // Check backend health
  static Future<bool> checkBackendHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'UP';
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  // Login API
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'role': role,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        currentUserId = data['id'] as int?;
        currentUserName = data['name'] as String?;
        currentUserEmail = data['email'] as String?;
        _sessionToken = data['token'] as String?;
        return {
          'success': true,
          'data': data,
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Invalid email or password',
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Cannot connect to backend. Check that Java is running.',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        currentUserId = data['id'] as int?;
        currentUserName = data['name'] as String?;
        currentUserEmail = data['email'] as String?;
        _sessionToken = data['token'] as String?;
        return {'success': true, 'data': data};
      }
      return {'success': false, 'message': data['message'] ?? 'Could not create your account.'};
    } catch (_) {
      return {'success': false, 'message': 'Cannot connect to backend. Check that Java is running.'};
    }
  }

  static Future<Map<String, dynamic>> registerForEvent({
    required String eventKey,
    required String title,
    required String location,
    required DateTime eventDate,
  }) async {
    if (currentUserId == null) return {'success': false, 'message': 'Please sign in again to register.'};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/events/register'),
        headers: {'Content-Type': 'application/json', if (_sessionToken != null) 'Authorization': 'Bearer $_sessionToken'},
        body: jsonEncode({
          'eventKey': eventKey,
          'title': title,
          'location': location,
          'eventDate': eventDate.toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return response.statusCode == 201
          ? {'success': true, 'data': data}
          : {'success': false, 'message': data['message'] ?? 'Could not register for this event.'};
    } catch (_) {
      return {'success': false, 'message': 'Could not reach the event registration service.'};
    }
  }
}

