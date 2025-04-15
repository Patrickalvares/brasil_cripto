import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MarketStats extends StatelessWidget {
  final double? marketCap;
  final double? totalVolume;
  final int? marketCapRank;
  final double? high24h;
  final double? low24h;

  const MarketStats({
    super.key,
    this.marketCap,
    this.totalVolume,
    this.marketCapRank,
    this.high24h,
    this.low24h,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('market_stats'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        StatRow(
          label: 'market_cap'.tr(),
          value: marketCap != null ? formatter.format(marketCap) : '-',
        ),
        StatRow(
          label: 'volume_24h'.tr(),
          value: totalVolume != null ? formatter.format(totalVolume) : '-',
        ),
        StatRow(label: 'market_rank'.tr(), value: marketCapRank != null ? '#$marketCapRank' : '-'),
        StatRow(label: 'high_24h'.tr(), value: high24h != null ? formatter.format(high24h) : '-'),
        StatRow(label: 'low_24h'.tr(), value: low24h != null ? formatter.format(low24h) : '-'),
      ],
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String value;

  const StatRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
