class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final String level; // Fresh, Mid, Senior, Lead, Director
  final List<String> skills;
  final String description;
  final String link; // Added for job URL

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.experience,
    required this.level,
    required this.skills,
    required this.description,
    this.link = "", // Default empty string
  });

  factory JobModel.fromMock(Map<String, dynamic> data) {
    return JobModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? '',
      experience: data['experience'] ?? '',
      level: data['level'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      description: data['description'] ?? '',
      link: data['link'] ?? '',
    );
  }
}
