import 'package:flutter/material.dart';

import '../../../core/common_widgets/coin_list_item.dart';
import '../../../domain/entities/coin.dart';
import '../../coin_detail/coin_detail_view.dart';
import '../search_viewmodel.dart';

class SearchResults extends StatelessWidget {
  final List<Coin> coins;
  final SearchViewModel viewModel;

  const SearchResults({super.key, required this.coins, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: coins.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final moeda = coins[index];
        return CoinListItem(
          coin: moeda,
          showChart: false,
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
    );
  }
}
