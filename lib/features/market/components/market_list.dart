import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/common_widgets/coin_list_item.dart';
import '../../../domain/entities/coin.dart';
import '../../coin_detail/coin_detail_view.dart';
import '../market_viewmodel.dart';

class MarketList extends StatelessWidget {
  final List<Coin> coins;
  final bool isLoading;
  final bool hasMoreData;
  final ScrollController scrollController;
  final MarketViewModel viewModel;
  final Future<void> Function() onRefresh;

  const MarketList({
    super.key,
    required this.coins,
    required this.isLoading,
    required this.hasMoreData,
    required this.scrollController,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: coins.length + (hasMoreData || isLoading ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          if (index == coins.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text('loading'.tr()),
                  ],
                ),
              ),
            );
          }

          final moeda = coins[index];
          return CoinListItem(
            coin: moeda,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CoinDetailView(coinId: moeda.id)),
              );
            },
            onFavoriteToggle: () {
              viewModel.alternarFavorito(moeda.id);
            },
          );
        },
      ),
    );
  }
}
