import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'AIzaSyB2r_JuShhxx59wsvwPUDRyIILLosHjMQI';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": message}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
      }

      print('AIService Error: ${response.statusCode} - ${response.body}');
      return "I'm having trouble connecting right now. Please try again later.";
    } catch (e) {
      print('AIService Exception: $e');
      return "An error occurred. Please check your internet connection.";
    }
  }
}