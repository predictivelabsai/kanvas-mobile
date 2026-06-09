import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:kanvas/config/api_config.dart';
import 'package:kanvas/models/chat.dart';

class ChatService {
  Stream<ChatEvent> streamChat({
    required String message,
    int? sessionId,
    required String token,
  }) async* {
    final uri = Uri.parse('${ApiConfig.baseUrl}/app/chat');

    final request = http.Request('POST', uri);
    request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    request.headers['Accept'] = 'text/event-stream';
    if (token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final params = <String, String>{'msg': message};
    if (sessionId != null) {
      params['sid'] = sessionId.toString();
    }
    request.body = params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      yield ErrorEvent('HTTP ${response.statusCode}: $body');
      return;
    }

    String buffer = '';

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      buffer += chunk;

      while (true) {
        final eventEnd = buffer.indexOf('\n\n');
        if (eventEnd == -1) break;

        final rawEvent = buffer.substring(0, eventEnd);
        buffer = buffer.substring(eventEnd + 2);

        String? eventName;
        String? eventData;

        for (final line in rawEvent.split('\n')) {
          if (line.startsWith('event: ')) {
            eventName = line.substring(7).trim();
          } else if (line.startsWith('data: ')) {
            eventData = line.substring(6);
          }
        }

        if (eventName != null && eventData != null) {
          try {
            final json = jsonDecode(eventData) as Map<String, dynamic>;
            yield parseSseEvent(eventName, json);
          } catch (e) {
            yield ErrorEvent('Failed to parse SSE event: $e');
          }
        }
      }
    }
  }
}
