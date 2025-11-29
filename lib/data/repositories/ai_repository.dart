import '../../services/ai_service.dart';

class AIRepository {
  final AIService _aiService = AIService();

  Future<String> sendMessage(String message) async {
    return await _aiService.sendMessage(message);
  }
}