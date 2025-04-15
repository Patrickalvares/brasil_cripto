import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/coin.dart';

class CoinListItem extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showChart;

  const CoinListItem({
    super.key,
    required this.coin,
    this.onTap,
    this.onFavoriteToggle,
    this.showChart = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final textTheme = Theme.of(context).textTheme;
    final isPositiveChange = (coin.priceChangePercentage24h ?? 0) >= 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 40,
                height: 40,
                child:
                    coin.image != null
                        ? CachedNetworkImage(
                          imageUrl: coin.image!,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                        : const Icon(Icons.monetization_on),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(coin.symbol.toUpperCase(), style: textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 5),

            if (showChart && coin.sparklineData != null)
              SizedBox(
                width: 60,
                height: 30,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _createSpots(coin.sparklineData!),
                        isCurved: true,
                        color: isPositiveChange ? Colors.green : Colors.red,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              isPositiveChange
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                    lineTouchData: const LineTouchData(enabled: false),
                  ),
                ),
              ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    coin.currentPrice != null ? formatter.format(coin.currentPrice) : '-',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    coin.priceChangePercentage24h != null
                        ? '${coin.priceChangePercentage24h! >= 0 ? '+' : ''}${coin.priceChangePercentage24h!.toStringAsFixed(2)}%'
                        : '-',
                    style: TextStyle(
                      color: isPositiveChange ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (onFavoriteToggle != null) ...[
              IconButton(
                icon: Icon(
                  coin.isFavorite ? Icons.star : Icons.star_border,
                  color: coin.isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ],
        ),
      ),
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
