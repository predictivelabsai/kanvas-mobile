import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kanvas/providers/auth_provider.dart';
import 'package:kanvas/screens/home_screen.dart';
import 'package:kanvas/screens/about_screen.dart';
import 'package:kanvas/screens/contact_screen.dart';
import 'package:kanvas/screens/shared_session_screen.dart';
import 'package:kanvas/screens/auth/login_screen.dart';
import 'package:kanvas/screens/auth/register_screen.dart';
import 'package:kanvas/screens/auth/forgot_password_screen.dart';
import 'package:kanvas/screens/chat_screen.dart';
import 'package:kanvas/screens/profile_screen.dart';
import 'package:kanvas/screens/app_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

const _publicPaths = {'/', '/about', '/contact'};
const _authPaths = {'/auth/login', '/auth/register', '/auth/forgot'};

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/chat',
    redirect: (context, state) {
      final path = state.uri.path;

      // Allow public paths and shared session links without auth
      if (_publicPaths.contains(path) || path.startsWith('/shared/')) {
        return null;
      }

      // Skip auth redirect for now — allow unauthenticated access to all routes
      // TODO: Re-enable once auth token flow is finalized
      if (!isLoggedIn && !_authPaths.contains(path)) {
        return null;
      }

      // Logged in trying to access auth routes -> chat
      if (isLoggedIn && _authPaths.contains(path)) {
        return '/chat';
      }

      return null;
    },
    routes: [
      // --- Public routes ---
      GoRoute(
        path: '/',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/about',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/shared/:token',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            SharedSessionScreen(token: state.pathParameters['token']!),
      ),

      // --- Auth routes ---
      GoRoute(
        path: '/auth/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/forgot',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // --- Protected routes (bottom nav shell) ---
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatScreen()),
            routes: [
              GoRoute(
                path: ':sessionId',
                builder: (context, state) {
                  final sessionId = int.tryParse(
                    state.pathParameters['sessionId'] ?? '',
                  );
                  return ChatScreen(sessionId: sessionId);
                },
              ),
            ],
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
});
