import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common_widgets/coin_list_item.dart';
import '../../core/common_widgets/error_message.dart';
import '../../core/common_widgets/loading_indicator.dart';
import '../coin_detail/coin_detail_view.dart';
import 'favorites_state.dart';
import 'favorites_viewmodel.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().carregarFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        if (state.status == FavoritesStatus.inicial || state.status == FavoritesStatus.carregando) {
          return const CoinLoadingIndicator();
        }

        if (state.status == FavoritesStatus.erro) {
          return ErrorMessage(
            message: state.mensagemErro,
            onRetry: () => viewModel.carregarFavoritos(),
          );
        }

        if (state.status == FavoritesStatus.vazio) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_border, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text('noFavorites'.tr(), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'addFavorites'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.carregarFavoritos(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.moedasFavoritas.length,
            separatorBuilder:
                (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final moeda = state.moedasFavoritas[index];
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
                  return await _showConfirmacaoExclusao(context);
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
      },
    );
  }

  Future<bool> _showConfirmacaoExclusao(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('removeFavorite'.tr()),
              content: Text('removeConfirmation'.tr()),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('remove'.tr()),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
