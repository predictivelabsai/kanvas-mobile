import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kanvas/config/theme.dart';
import 'package:kanvas/models/chat.dart';

/// Renders a chat [Artifact] of kind `chart`.
///
/// The API ([tools/sql_query.py]) emits a Plotly-style figure:
/// ```
/// { "kind": "chart", "title": "...", "subtitle": "N data points",
///   "figure": { "data": [ { "type": "bar"|"scatter"|"pie",
///                            "x"|"labels": [...], "y"|"values": [...] } ],
///              "layout": { "xaxis": {"title": ...}, "yaxis": {"title": ...} } } }
/// ```
/// We translate the first trace into an fl_chart bar / line / pie chart.
/// Anything we can't parse degrades to a titled card so the user still sees
/// *something* rather than raw JSON.
class ChartArtifactCard extends StatelessWidget {
  final Artifact artifact;

  const ChartArtifactCard({super.key, required this.artifact});

  static const _palette = <Color>[
    Color(0xFF1A1A1A),
    Color(0xFF2563EB),
    Color(0xFF16A34A),
    Color(0xFF9333EA),
    Color(0xFFEA580C),
    Color(0xFF0891B2),
    Color(0xFFCA8A04),
    Color(0xFFDC2626),
    Color(0xFF6B7280),
    Color(0xFF4F46E5),
  ];

  Map<String, dynamic>? get _trace {
    final figure = artifact.data['figure'];
    if (figure is! Map) return null;
    final traces = figure['data'];
    if (traces is! List || traces.isEmpty) return null;
    final first = traces.first;
    return first is Map ? first.cast<String, dynamic>() : null;
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static String _shortNum(double v) {
    final a = v.abs();
    if (a >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
    if (a >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (a >= 1e3) return '${(v / 1e3).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  static String _shortLabel(String s) =>
      s.length <= 10 ? s : '${s.substring(0, 9)}…';

  @override
  Widget build(BuildContext context) {
    final trace = _trace;
    final type = (trace?['type'] as String?)?.toLowerCase() ?? '';
    final subtitle = artifact.data['subtitle']?.toString();

    Widget chart;
    if (trace == null) {
      chart = _fallback();
    } else if (type == 'pie') {
      chart = _pie(trace);
    } else if (type == 'scatter' || type == 'line') {
      chart = _line(trace);
    } else {
      chart = _bar(trace);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, size: 16, color: AppTheme.gray500),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  artifact.title ?? 'Chart',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (subtitle != null && subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 22),
              child: Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: AppTheme.gray500),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  // ── Bar ────────────────────────────────────────────────────────────
  Widget _bar(Map<String, dynamic> trace) {
    final xs = (trace['x'] as List? ?? const [])
        .map((e) => e.toString())
        .toList();
    final ys = (trace['y'] as List? ?? const []).map(_toDouble).toList();
    final n = xs.length < ys.length ? xs.length : ys.length;
    if (n == 0) return _fallback();

    final maxY = ys.take(n).fold<double>(0, (m, v) => v > m ? v : m);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY <= 0 ? 1 : maxY * 1.15,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, __) => BarTooltipItem(
              '${xs[group.x]}\n${_shortNum(rod.toY)}',
              const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppTheme.gray100, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (v, _) => Text(
                _shortNum(v),
                style: TextStyle(fontSize: 9, color: AppTheme.gray400),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (v, meta) {
                final i = v.toInt();
                if (i < 0 || i >= n) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      _shortLabel(xs[i]),
                      style: TextStyle(fontSize: 8, color: AppTheme.gray500),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < n; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: ys[i],
                  color: _palette[i % _palette.length],
                  width: n > 10 ? 9 : 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(3),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ── Line ───────────────────────────────────────────────────────────
  Widget _line(Map<String, dynamic> trace) {
    final xs = (trace['x'] as List? ?? const [])
        .map((e) => e.toString())
        .toList();
    final ys = (trace['y'] as List? ?? const []).map(_toDouble).toList();
    final n = xs.length < ys.length ? xs.length : ys.length;
    if (n == 0) return _fallback();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppTheme.gray100, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (v, _) => Text(
                _shortNum(v),
                style: TextStyle(fontSize: 9, color: AppTheme.gray400),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: (n / 6).ceilToDouble().clamp(1, n.toDouble()),
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= n) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      _shortLabel(xs[i]),
                      style: TextStyle(fontSize: 8, color: AppTheme.gray500),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [for (var i = 0; i < n; i++) FlSpot(i.toDouble(), ys[i])],
            isCurved: true,
            color: AppTheme.ink,
            barWidth: 2,
            dotData: FlDotData(
              show: n <= 20,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 3,
                color: AppTheme.ink,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.ink.withValues(alpha: 0.06),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pie ────────────────────────────────────────────────────────────
  Widget _pie(Map<String, dynamic> trace) {
    final labels = (trace['labels'] as List? ?? const [])
        .map((e) => e.toString())
        .toList();
    final values = (trace['values'] as List? ?? const [])
        .map(_toDouble)
        .toList();
    final n = labels.length < values.length ? labels.length : values.length;
    if (n == 0) return _fallback();
    final total = values.take(n).fold<double>(0, (s, v) => s + v);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1.5,
              centerSpaceRadius: 30,
              sections: [
                for (var i = 0; i < n; i++)
                  PieChartSectionData(
                    value: values[i],
                    color: _palette[i % _palette.length],
                    radius: 52,
                    title: total > 0
                        ? '${(values[i] / total * 100).toStringAsFixed(0)}%'
                        : '',
                    titleStyle: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < n && i < 8; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _palette[i % _palette.length],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _shortLabel(labels[i]),
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        artifact.title ?? 'Chart data unavailable',
        style: TextStyle(fontSize: 12, color: AppTheme.gray500),
      ),
    );
  }
}
