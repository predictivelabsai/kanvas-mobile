import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanvas/config/theme.dart';
import 'package:kanvas/screens/home_screen.dart';

Widget _wrapWidget(Widget child) {
  return MaterialApp(theme: AppTheme.light, home: child);
}

void main() {
  group('HomeScreen', () {
    testWidgets('renders Kanvas title in hero section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.text('Kanvas'), findsOneWidget);
    });

    testWidgets('renders hero subtitle', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.text('Your AI Art Advisor.'), findsOneWidget);
    });

    testWidgets('renders Sign In buttons', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsNWidgets(2));
    });

    testWidgets('renders Learn More button in hero section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.widgetWithText(OutlinedButton, 'Learn More'), findsOneWidget);
    });

    testWidgets('renders stats row with key numbers', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.text('8'), findsOneWidget);
      expect(find.text('AI Agents'), findsOneWidget);
      expect(find.text('1000+'), findsOneWidget);
      expect(find.text('Artists'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
      expect(find.text('Countries'), findsOneWidget);
    });

    testWidgets('renders What Kanvas Does section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('What Kanvas Does'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('What Kanvas Does'), findsOneWidget);
    });

    testWidgets('renders Artist Research feature card', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('Artist Research'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Artist Research'), findsOneWidget);
    });

    testWidgets('renders Market Intelligence feature card', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('Market Intelligence'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Market Intelligence'), findsOneWidget);
    });

    testWidgets('renders How it Works section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('How it Works'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('How it Works'), findsOneWidget);
    });

    testWidgets('renders three how-it-works steps', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('Ask About Art'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Ask About Art'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('AI Agents Research'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('AI Agents Research'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Get Expert Insights'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Get Expert Insights'), findsOneWidget);
    });

    testWidgets('renders Specialist AI Agents section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('Specialist AI Agents'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Specialist AI Agents'), findsOneWidget);
    });

    testWidgets('renders bottom CTA section', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('Ready to explore the art market?'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Ready to explore the art market?'), findsOneWidget);
    });

    testWidgets('renders About and Contact links in footer', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      await tester.scrollUntilVisible(
        find.text('About'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('About'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);
    });

    testWidgets('renders four stat cards', (tester) async {
      await tester.pumpWidget(_wrapWidget(const HomeScreen()));

      expect(find.byType(Card), findsAtLeast(4));
    });
  });
}
