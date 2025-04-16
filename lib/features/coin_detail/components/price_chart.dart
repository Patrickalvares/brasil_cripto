import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final List<double>? sparklineData;
  final double? priceChangePercentage24h;
  final String? symbol; // Adicionado para identificar a moeda

  const PriceChart({super.key, this.sparklineData, this.priceChangePercentage24h, this.symbol});

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
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 48, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text(
                    'no_chart_data'.tr(),
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

    // Cálculo de valores para o eixo Y (preços)
    final minY = sparklineData!.reduce((a, b) => a < b ? a : b);
    final maxY = sparklineData!.reduce((a, b) => a > b ? a : b);

    // Detectar se é uma stablecoin baseado no símbolo ou na volatilidade
    final bool isStablecoin =
        _isStablecoin(symbol) || (maxY > 0 && (maxY - minY) / maxY < 0.005); // 0.5% de variação

    // Obter datas para o eixo X
    final today = DateTime.now();
    final dates = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));

    final dayToTranslationKey = [
      'day_sun',
      'day_mon',
      'day_tue',
      'day_wed',
      'day_thu',
      'day_fri',
      'day_sat',
    ];

    // Para stablecoins, podemos exagerar os movimentos de preço para torná-los visíveis
    List<double> displayData = sparklineData!;
    double adjustedMinY = minY;
    double adjustedMaxY = maxY;

    if (isStablecoin) {
      // Encontrar o preço médio
      final avgPrice = sparklineData!.reduce((a, b) => a + b) / sparklineData!.length;

      // Calcular a diferença máxima do preço médio
      final maxDiff = sparklineData!
          .map((p) => (p - avgPrice).abs())
          .reduce((a, b) => a > b ? a : b);

      // Se a variação for muito pequena, exagerar as diferenças
      if (maxDiff / avgPrice < 0.01) {
        // Menos de 1% de variação
        // Exagerar as diferenças por um fator
        final scaleFactor = 0.01 / (maxDiff / avgPrice);
        displayData =
            sparklineData!.map((p) {
              // Calcular a diferença exagerada, mas manter o preço base
              final diff = (p - avgPrice) * scaleFactor;
              return avgPrice + diff;
            }).toList();

        // Recalcular min e max para os dados escalados
        adjustedMinY = displayData.reduce((a, b) => a < b ? a : b);
        adjustedMaxY = displayData.reduce((a, b) => a > b ? a : b);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('price_chart_7d'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Stack(
          children: [
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval:
                          isStablecoin
                              ? (adjustedMaxY - adjustedMinY) / 2
                              : // Apenas 3 linhas horizontais para stablecoins
                              (adjustedMaxY - adjustedMinY) /
                                  4, // Linhas normais para outras moedas
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
                              final weekday = dates[dayIndex].weekday % 7;
                              final day = dayToTranslationKey[weekday];

                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  day.tr(),
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
                          showTitles:
                              isStablecoin
                                  ? false
                                  : true, // Esconder completamente para stablecoins
                          reservedSize: 60,
                          interval:
                              isStablecoin
                                  ? (adjustedMaxY - adjustedMinY) / 2
                                  : // Apenas 3 valores para stablecoins
                                  (adjustedMaxY - adjustedMinY) /
                                      4, // Formato normal para outras moedas
                          getTitlesWidget: (value, meta) {
                            if (isStablecoin) {
                              return const SizedBox.shrink(); // Não mostrar para stablecoins
                            }

                            // Formato para moedas normais
                            String formattedValue;
                            if (maxY > 1000) {
                              formattedValue = '\$${(value / 1000).toStringAsFixed(1)}K';
                            } else if (maxY > 1) {
                              formattedValue = '\$${value.toStringAsFixed(2)}';
                            } else {
                              formattedValue = '\$${value.toStringAsFixed(4)}';
                            }

                            // Garantir que o texto não fique muito longo
                            if (formattedValue.length > 8) {
                              formattedValue = formattedValue.substring(0, 8);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                formattedValue,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontSize: 9,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                    minY: adjustedMinY * 0.98,
                    maxY: adjustedMaxY * 1.02,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _createSpots(displayData),
                        isCurved: true,
                        color: isPositiveChange ? Colors.green : Colors.red,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              isPositiveChange
                                  ? Colors.green.withAlpha(26)
                                  : Colors.red.withAlpha(26),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Theme.of(context).colorScheme.surface,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            final dayIndex =
                                (touchedSpot.x / (sparklineData!.length - 1) * 6).round();

                            String displayDate = '';
                            if (dayIndex >= 0 && dayIndex < 7) {
                              final day = dates[dayIndex].day;
                              final month = DateFormat(
                                'MMM',
                                context.locale.toString(),
                              ).format(dates[dayIndex]);
                              displayDate = '$month $day';
                            }

                            // Usar o valor real para o tooltip, não o valor ajustado
                            final realIndex = touchedSpot.x.round();
                            final realValue =
                                realIndex >= 0 && realIndex < sparklineData!.length
                                    ? sparklineData![realIndex]
                                    : touchedSpot.y;

                            final formatter = NumberFormat.currency(symbol: '\$');
                            return LineTooltipItem(
                              '${formatter.format(realValue)}\n$displayDate',
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
            // Overlay para stablecoins mostrando valores fixos à esquerda
            if (isStablecoin)
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${maxY.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      '\$${((maxY + minY) / 2).toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      '\$${minY.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            // Nota para stablecoins indicando escala exagerada
            if (isStablecoin && displayData != sparklineData)
              Positioned(
                right: 16,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Escala ajustada',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Verificar se é uma stablecoin conhecida pelo símbolo
  bool _isStablecoin(String? symbol) {
    if (symbol == null) return false;

    final stablecoins = [
      'usdc',
      'usdt',
      'busd',
      'dai',
      'tusd',
      'usdp',
      'frax',
      'lusd',
      'susd',
      'gusd',
    ];

    return stablecoins.contains(symbol.toLowerCase());
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
