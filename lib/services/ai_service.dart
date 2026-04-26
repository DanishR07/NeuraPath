import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // IMPORTANT: Replace with your actual Groq API Key
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile", // High-performance Groq model
          "messages": [
            {
              "role": "user",
              "content": message,
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'];
        }
      }

      print('Groq AIService Error: ${response.statusCode} - ${response.body}');
      return "I'm having trouble connecting to Groq right now. Please check your API key or try again later.";
    } catch (e) {
      print('Groq AIService Exception: $e');
      return "An error occurred. Please check your internet connection.";
    }
  }
}
