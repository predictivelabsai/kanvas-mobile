import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:kanvas/services/report_service.dart';
import 'auth_service_test.mocks.dart';

void main() {
  test('submits AI response report with session context', () async {
    final client = MockApiClient();
    final service = ReportService(client);
    when(
      client.post('/reports/ai-content', data: anyNamed('data')),
    ).thenAnswer((_) async => {'ok': true});

    await service.reportAIContent(
      reason: 'Misleading or inaccurate',
      responseContent: 'Reported answer',
      sessionId: 42,
    );

    final verification = verify(
      client.post('/reports/ai-content', data: captureAnyNamed('data')),
    );
    verification.called(1);
    expect(verification.captured.single, {
      'reason': 'Misleading or inaccurate',
      'response_content': 'Reported answer',
      'session_id': 42,
    });
  });
}
