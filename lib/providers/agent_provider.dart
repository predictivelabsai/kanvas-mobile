import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanvas/models/agent.dart';
import 'package:kanvas/services/agent_service.dart';
import 'package:kanvas/providers/auth_provider.dart';

final agentsProvider = FutureProvider<List<AgentOut>>((ref) async {
  final service = AgentService(ref.read(apiClientProvider));
  return service.listAgents();
});
