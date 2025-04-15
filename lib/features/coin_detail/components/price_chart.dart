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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('price_chart_7d'.tr(), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 48, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'No chart data available',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final isPositiveChange = (priceChangePercentage24h ?? 0) >= 0;
    final formatter = NumberFormat.currency(symbol: '\$');

    // Cálculo de valores para o eixo Y (preços)
    final minY = sparklineData!.reduce((a, b) => a < b ? a : b);
    final maxY = sparklineData!.reduce((a, b) => a > b ? a : b);

    // Calcular intervalos para o eixo Y
    final yRange = maxY - minY;
    final yInterval = yRange / 4; // 5 pontos (incluindo min e max)

    // Obter datas para o eixo X
    final today = DateTime.now();
    final dates = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price_chart_7d'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: yInterval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: Colors.grey.withAlpha(51), strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (sparklineData!.length / 6).floorToDouble(),
                      getTitlesWidget: (value, meta) {
                        final dayIndex = (value / (sparklineData!.length - 1) * 6).round();
                        if (dayIndex >= 0 && dayIndex < 7) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('EEE').format(dates[dayIndex]),
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: yInterval,
                      getTitlesWidget: (value, meta) {
                        String formattedValue;
                        if (maxY > 1000) {
                          formattedValue = '\$${(value / 1000).toStringAsFixed(1)}K';
                        } else if (maxY > 1) {
                          formattedValue = '\$${value.toStringAsFixed(2)}';
                        } else {
                          formattedValue = '\$${value.toStringAsFixed(4)}';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            formattedValue,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (sparklineData!.length - 1).toDouble(),
                minY: minY * 0.98,
                maxY: maxY * 1.02,
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
                      color:
                          isPositiveChange ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.surface,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        // Calcular o dia correspondente ao ponto tocado
                        final dayIndex = (touchedSpot.x / (sparklineData!.length - 1) * 6).round();
                        final displayDate =
                            dayIndex >= 0 && dayIndex < 7
                                ? DateFormat('MMM dd').format(dates[dayIndex])
                                : '';

                        return LineTooltipItem(
                          '${formatter.format(touchedSpot.y)}\n$displayDate',
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
        ),
      ],
    );
  }

  List<FlSpot> _createSpots(List<double> data) {
    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      if (data[i].isFinite) {
        spots.add(FlSpot(i.toDouble(), data[i]));
      }
    }
    return spots;
  }
}
