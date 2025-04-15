import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/common_widgets/coin_list_item.dart';
import '../../../domain/entities/coin.dart';
import '../../coin_detail/coin_detail_view.dart';
import '../favorites_viewmodel.dart';
import 'favorite_delete_dialog.dart';

class FavoritesList extends StatelessWidget {
  final List<Coin> coins;
  final FavoritesViewModel viewModel;
  final Future<void> Function() onRefresh;

  const FavoritesList({
    super.key,
    required this.coins,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: coins.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final moeda = coins[index];
          return Dismissible(
            key: Key(moeda.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await FavoriteDeleteDialog.show(context);
            },
            onDismissed: (direction) {
              viewModel.removerDosFavoritos(moeda.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('removedFrom'.tr(namedArgs: {'name': moeda.name})),
                  action: SnackBarAction(
                    label: 'undo'.tr(),
                    onPressed: () {
                      viewModel.carregarFavoritos();
                    },
                  ),
                ),
              );
            },
            child: CoinListItem(
              coin: moeda,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoinDetailView(coinId: moeda.id)),
                ).then((_) => viewModel.carregarFavoritos());
              },
              onFavoriteToggle: () {
                viewModel.removerDosFavoritos(moeda.id);
              },
            ),
          );
        },
      ),
    );
  }
}
