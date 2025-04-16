import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MarketEmpty extends StatelessWidget {
  const MarketEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.currency_bitcoin, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('no_market_data'.tr(), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
