import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<double>? sparklineData;
  final double? priceChangePercentage24h;

  const PriceChart({super.key, this.sparklineData, this.priceChangePercentage24h});

  @override
  Widget build(BuildContext context) {
    if (sparklineData == null || sparklineData!.isEmpty) {
      return const SizedBox.shrink();
    }

    final isPositiveChange = (priceChangePercentage24h ?? 0) >= 0;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price_chart_7d'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _createSpots(sparklineData!),
                  isCurved: true,
                  color: isPositiveChange ? Colors.green : Colors.red,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: isPositiveChange ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.surface,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      return LineTooltipItem(
                        formatter.format(touchedSpot.y),
                        TextStyle(
                          color: isPositiveChange ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _createSpots(List<double> data) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }
    return spots;
  }
}
