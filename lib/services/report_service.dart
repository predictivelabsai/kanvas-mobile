import 'package:kanvas/services/api_client.dart';

class ReportService {
  final ApiClient _client;

  ReportService(this._client);

  Future<void> reportAIContent({
    required String reason,
    required String responseContent,
    int? sessionId,
    String? details,
  }) async {
    final data = <String, dynamic>{
      'reason': reason,
      'response_content': responseContent,
    };
    if (sessionId case final sessionId?) {
      data['session_id'] = sessionId;
    }
    if (details?.trim() case final details? when details.isNotEmpty) {
      data['details'] = details;
    }

    await _client.post(
      '/reports/ai-content',
      data: data,
    );
  }
}
