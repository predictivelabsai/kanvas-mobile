import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/chat.dart';
import 'package:kanvas/screens/chat/widgets/chart_artifact_card.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SizedBox(width: 400, child: child)),
);

Artifact _artifact(String type, {bool pie = false}) => Artifact.fromJson({
  'kind': 'chart',
  'title': 'Top Artists by Sales',
  'subtitle': '3 data points',
  'figure': {
    'data': [
      pie
          ? {
              'type': 'pie',
              'labels': ['Künnapu', 'Lapin', 'Vint'],
              'values': [120000, 80000, 40000],
            }
          : {
              'type': type,
              'x': ['Künnapu', 'Lapin', 'Vint'],
              'y': [120000, 80000, 40000],
            },
    ],
    'layout': {
      'xaxis': {'title': 'Artist'},
      'yaxis': {'title': 'Sales'},
    },
  },
});

void main() {
  group('ChartArtifactCard', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(ChartArtifactCard(artifact: _artifact('bar'))),
      );
      expect(find.text('Top Artists by Sales'), findsOneWidget);
      expect(find.text('3 data points'), findsOneWidget);
    });

    testWidgets('renders a bar chart', (tester) async {
      await tester.pumpWidget(
        _wrap(ChartArtifactCard(artifact: _artifact('bar'))),
      );
      expect(find.byType(BarChart), findsOneWidget);
    });

    testWidgets('renders a line chart for scatter type', (tester) async {
      await tester.pumpWidget(
        _wrap(ChartArtifactCard(artifact: _artifact('scatter'))),
      );
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders a pie chart with legend', (tester) async {
      await tester.pumpWidget(
        _wrap(ChartArtifactCard(artifact: _artifact('pie', pie: true))),
      );
      expect(find.byType(PieChart), findsOneWidget);
      expect(find.text('Künnapu'), findsOneWidget); // legend entry
    });

    testWidgets('degrades gracefully when figure is missing', (tester) async {
      final bad = Artifact.fromJson({'kind': 'chart', 'title': 'Empty'});
      await tester.pumpWidget(_wrap(ChartArtifactCard(artifact: bad)));
      expect(tester.takeException(), isNull);
      expect(find.text('Empty'), findsWidgets);
    });
  });
}
