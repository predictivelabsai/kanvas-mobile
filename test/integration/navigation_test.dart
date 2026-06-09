import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/auth.dart';
import 'package:kanvas/models/agent.dart';
import 'package:kanvas/models/session.dart';
import 'package:kanvas/models/profile.dart';
import 'package:kanvas/providers/auth_provider.dart';
import 'package:kanvas/providers/agent_provider.dart';
import 'package:kanvas/providers/session_provider.dart';
import 'package:kanvas/providers/profile_provider.dart';
import 'package:kanvas/screens/chat_screen.dart';
import 'package:kanvas/screens/profile_screen.dart';
import 'package:kanvas/screens/app_scaffold.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthResponse?> build() async => const AuthResponse(
    token: 'test-token',
    email: 'test@example.com',
    name: 'Test User',
    userId: 1,
  );
}

class _FakeProfileNotifier extends ProfileNotifier {
  @override
  Future<UserProfile?> build() async => const UserProfile(
    name: 'Test User',
    email: 'test@example.com',
    currency: 'EUR',
    language: 'en',
  );
}

late GoRouter _router;

Widget _buildNavTestApp({String initialLocation = '/chat'}) {
  _router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authProvider.overrideWith(() => _FakeAuthNotifier()),
      agentsProvider.overrideWith((ref) => <AgentOut>[]),
      sessionsProvider.overrideWith((ref) => <SessionSummary>[]),
      profileProvider.overrideWith(() => _FakeProfileNotifier()),
    ],
    child: MaterialApp.router(theme: AppTheme.light, routerConfig: _router),
  );
}

void main() {
  group('Sidebar navigation integration', () {
    testWidgets('starts on Chat tab', (tester) async {
      await tester.pumpWidget(_buildNavTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Kanvas AI'), findsOneWidget);
      expect(find.text('Kanvas AI Advisor'), findsOneWidget);
    });

    testWidgets('Profile screen shows account section', (tester) async {
      await tester.pumpWidget(_buildNavTestApp(initialLocation: '/profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile & Preferences'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('can navigate between screens via router', (tester) async {
      await tester.pumpWidget(_buildNavTestApp());
      await tester.pumpAndSettle();

      expect(find.text('Kanvas AI Advisor'), findsOneWidget);

      _router.go('/profile');
      await tester.pumpAndSettle();
      expect(find.text('Profile & Preferences'), findsOneWidget);

      _router.go('/chat');
      await tester.pumpAndSettle();
      expect(find.text('Kanvas AI Advisor'), findsOneWidget);
    });

    testWidgets('AppScaffold wraps all routes', (tester) async {
      await tester.pumpWidget(_buildNavTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(AppScaffold), findsOneWidget);

      _router.go('/profile');
      await tester.pumpAndSettle();
      expect(find.byType(AppScaffold), findsOneWidget);
    });
  });
}
