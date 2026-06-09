import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanvas/models/session.dart';
import 'package:kanvas/services/session_service.dart';
import 'package:kanvas/providers/auth_provider.dart';

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref.read(apiClientProvider));
});

final sessionsProvider = FutureProvider<List<SessionSummary>>((ref) async {
  final service = ref.read(sessionServiceProvider);
  return service.listSessions();
});
