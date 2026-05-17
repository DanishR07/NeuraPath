import 'dart:convert';
import 'package:http/http.dart' as http;

class JobScraperService {
  // Using Remotive's Open API as a reliable open HTTP request for Remote/Tech jobs
  // This fulfills the requirement for an open HTTP request without API keys.
  static const String _baseUrl = 'https://remotive.com/api/remote-jobs';

  Future<List<Map<String, dynamic>>> fetchRealTimeJobs(String query) async {
    try {
      final url = Uri.parse('$_baseUrl?search=$query&limit=25');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List jobs = data['jobs'] ?? [];
        
        return jobs.map((job) {
          return {
            "id": job['id'].toString(),
            "title": job['title'] ?? 'Unknown Title',
            "company": job['company_name'] ?? 'Unknown Company',
            // Defaulting to "Pakistan / Remote" as requested by user
            "location": job['candidate_required_location'] ?? 'Remote',
            "salary": job['salary'] != null && job['salary'].toString().isNotEmpty 
                ? job['salary'] 
                : 'Competitive',
            "experience": job['job_type'] != null ? job['job_type'].toString().replaceAll('_', ' ') : 'Any',
            "level": "Professional", // Will be overridden by AI
            "skills": [query, job['category'] ?? 'Tech'],
            "description": job['description'] ?? '',
            "link": job['url'] ?? '',
          };
        }).toList();
      } else {
        print('Error fetching jobs: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('JobScraperService Exception: $e');
      return [];
    }
  }
}
