import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PriceInfo extends StatelessWidget {
  final double? currentPrice;
  final double? priceChangePercentage24h;

  const PriceInfo({super.key, this.currentPrice, this.priceChangePercentage24h});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final isPositiveChange = (priceChangePercentage24h ?? 0) >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              currentPrice != null ? formatter.format(currentPrice) : '-',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (priceChangePercentage24h != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositiveChange ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${priceChangePercentage24h! >= 0 ? '+' : ''}${priceChangePercentage24h!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: isPositiveChange ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'price_change_24h'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
