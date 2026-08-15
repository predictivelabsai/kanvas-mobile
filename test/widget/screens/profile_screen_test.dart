import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/profile.dart';
import 'package:kanvas/providers/profile_provider.dart';
import 'package:kanvas/screens/profile_screen.dart';

class _FakeProfileNotifier extends ProfileNotifier {
  final UserProfile? _profile;
  _FakeProfileNotifier(this._profile);

  @override
  Future<UserProfile?> build() async => _profile;
}

const _testProfile = UserProfile(
  name: 'Jane Doe',
  email: 'jane@example.com',
  phone: '+372 555 1234',
  country: 'Estonia',
  city: 'Tallinn',
  currency: 'EUR',
  language: 'en',
  preferredMediums: ['Oil on canvas', 'Watercolor'],
  preferredPeriods: ['Contemporary'],
  notifyWeeklyDigest: false,
);

Widget _buildProfileScreen({UserProfile? profile = _testProfile}) {
  return ProviderScope(
    overrides: [
      profileProvider.overrideWith(() => _FakeProfileNotifier(profile)),
    ],
    child: MaterialApp(theme: AppTheme.light, home: const ProfileScreen()),
  );
}

void main() {
  group('ProfileScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Profile & Preferences'), findsOneWidget);
    });

    testWidgets('renders Account section header', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders account fields pre-filled from profile', (
      tester,
    ) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.text('+372 555 1234'), findsOneWidget);
      expect(find.text('Estonia'), findsOneWidget);
      expect(find.text('Tallinn'), findsOneWidget);
    });

    testWidgets('renders Save Account button', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Save Account'), findsOneWidget);
    });

    testWidgets('renders Art Preferences section header', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Art Preferences'), findsOneWidget);
    });

    testWidgets('renders Preferred Mediums chip group', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Preferred Mediums'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Oil on canvas'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Watercolor'), findsOneWidget);
    });

    testWidgets('renders Preferred Periods chip group', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Preferred Periods'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Contemporary'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Modern'), findsOneWidget);
    });

    testWidgets('renders Save Preferences button', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Save Preferences'), findsOneWidget);
    });

    testWidgets('renders Notifications section header', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Notifications'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('renders notification toggle switch', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Weekly art market digest'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Weekly art market digest'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
    });

    testWidgets('renders Save Notifications button', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Save Notifications'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Save Notifications'), findsOneWidget);
    });

    testWidgets('renders privacy and account deletion controls', (
      tester,
    ) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Privacy & account deletion'),
        250,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Deletion help'), findsOneWidget);
      expect(find.text('Delete account'), findsOneWidget);
    });

    testWidgets('renders all three sections in scrollable form', (
      tester,
    ) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Art Preferences'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Notifications'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('shows login prompt when profile is null', (tester) async {
      await tester.pumpWidget(_buildProfileScreen(profile: null));
      await tester.pumpAndSettle();

      expect(find.text('Please log in to view profile.'), findsOneWidget);
    });

    testWidgets('renders three save buttons total', (tester) async {
      await tester.pumpWidget(_buildProfileScreen());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsNWidgets(3));
    });
  });
}
