import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/currency_provider.dart';
import '../../../core/services/injections.dart';

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
    final currencyProvider = i<CurrencyProvider>();

    return ValueListenableBuilder(
      valueListenable: currencyProvider,
      builder: (context, _, __) {
        final String currencySymbol = _getCurrencySymbol(currencyProvider.currency);
        final formatter = NumberFormat.currency(symbol: currencySymbol);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('market_stats'.tr(), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            StatRow(
              label: 'market_cap'.tr(),
              value: marketCap != null ? formatter.format(marketCap) : '-',
            ),
            Divider(color: Theme.of(context).colorScheme.outline),
            StatRow(
              label: 'volume_24h'.tr(),
              value: totalVolume != null ? formatter.format(totalVolume) : '-',
            ),
            Divider(color: Theme.of(context).colorScheme.outline),
            StatRow(
              label: 'market_rank'.tr(),
              value: marketCapRank != null ? '#$marketCapRank' : '-',
            ),
            Divider(color: Theme.of(context).colorScheme.outline),
            StatRow(
              label: 'high_24h'.tr(),
              value: high24h != null ? formatter.format(high24h) : '-',
            ),
            Divider(color: Theme.of(context).colorScheme.outline),
            StatRow(label: 'low_24h'.tr(), value: low24h != null ? formatter.format(low24h) : '-'),
          ],
        );
      },
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'brl':
        return 'R\$';
      case 'eur':
        return '€';
      case 'usd':
      default:
        return '\$';
    }
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String value;

  const StatRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            '$label:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
