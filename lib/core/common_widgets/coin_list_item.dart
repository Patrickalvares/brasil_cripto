import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w, bottom: 12.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: SizedBox(
                width: 40.w,
                height: 40.h,
                child:
                    coin.image != null
                        ? CachedNetworkImage(
                          imageUrl: coin.image!,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                        : Icon(Icons.monetization_on, size: 24.sp),
              ),
            ),
            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    coin.symbol.toUpperCase(),
                    style: textTheme.bodySmall?.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),

            if (showChart && coin.sparklineData != null)
              SizedBox(
                width: 60.w,
                height: 30.h,
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
                        barWidth: 2.w,
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
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    coin.currentPrice != null ? formatter.format(coin.currentPrice) : '-',
                    style: textTheme.titleMedium?.copyWith(fontSize: 13.sp),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    coin.priceChangePercentage24h != null
                        ? '${coin.priceChangePercentage24h! >= 0 ? '+' : ''}${coin.priceChangePercentage24h!.toStringAsFixed(2)}%'
                        : '-',
                    style: TextStyle(
                      color: isPositiveChange ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (onFavoriteToggle != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  coin.isFavorite ? Icons.star : Icons.star_border,
                  color: coin.isFavorite ? Colors.amber : Colors.grey,
                  size: 26.sp,
                ),
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
