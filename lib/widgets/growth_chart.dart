import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// رسم منحنى نمو مبني على fl_chart — يُستخدم لعرض جدول التراكم الشهري/السنوي
/// (حاسبة صندوق الاستثمار) أو لمقارنة الفائدة البسيطة بالمركبة (حاسبة 1).
class GrowthChart extends StatelessWidget {
  final List<FlSpot> spots;
  final String xLabel;
  final String yLabel;

  const GrowthChart({
    super.key,
    required this.spots,
    this.xLabel = 'الفترة',
    this.yLabel = 'القيمة',
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 8, right: 16),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 48),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: theme.colorScheme.primary,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// نسخة مبسّطة كأعمدة (Bar chart) — تُستخدم لمقارنة الفائدة البسيطة
/// بالمركبة في حاسبة 1، حسب "ملاحظة تصميم" في الشيت.
class ComparisonBarChart extends StatelessWidget {
  final List<MapEntry<String, double>> bars;

  const ComparisonBarChart({super.key, required this.bars});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxY = bars.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2;

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 48),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= bars.length) return const SizedBox.shrink();
                  return Text(bars[index].key, style: theme.textTheme.bodySmall);
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].value,
                    color: theme.colorScheme.primary,
                    width: 36,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
