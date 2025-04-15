import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common_widgets/coin_list_item.dart';
import '../../core/common_widgets/error_message.dart';
import '../../core/common_widgets/loading_indicator.dart';
import '../../core/common_widgets/search_bar_widget.dart';
import '../coin_detail/coin_detail_view.dart';
import 'search_state.dart';
import 'search_viewmodel.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;

        return Column(
          children: [
            CryptoSearchBar(
              initialQuery: state.ultimaConsulta,
              onSearch: (query) {
                viewModel.pesquisarMoedas(query);
              },
              onClear: () {
                viewModel.limparPesquisa();
              },
            ),
            Expanded(child: _buildResultadosPesquisa(viewModel, state)),
          ],
        );
      },
    );
  }

  Widget _buildResultadosPesquisa(SearchViewModel viewModel, SearchState state) {
    switch (state.status) {
      case SearchStatus.inicial:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text('searchCryptos'.tr(), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );

      case SearchStatus.pesquisando:
        return const CoinLoadingIndicator(itemCount: 5);

      case SearchStatus.sucesso:
        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.resultados.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final moeda = state.resultados[index];
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

      case SearchStatus.vazio:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text('noResults'.tr(), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('tryDifferentSearch'.tr(), style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );

      case SearchStatus.erro:
        return ErrorMessage(
          message: state.mensagemErro,
          onRetry: () {
            if (state.ultimaConsulta.isNotEmpty) {
              viewModel.pesquisarMoedas(state.ultimaConsulta);
            }
          },
        );
    }
  }
}
