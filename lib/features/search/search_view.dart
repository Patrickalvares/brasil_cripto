import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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

class _SearchViewState extends StatefulBaseState<SearchView, SearchViewModel> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (_, state, __) {
        String ultimaConsulta = '';
        if (state is SearchingState) {
          ultimaConsulta = state.ultimaConsulta;
        } else if (state is SearchSuccessState) {
          ultimaConsulta = state.ultimaConsulta;
        } else if (state is SearchErrorState) {
          ultimaConsulta = state.ultimaConsulta;
        } else if (state is SearchEmptyState) {
          ultimaConsulta = state.ultimaConsulta;
        }

        return Column(
          children: [
            CryptoSearchBar(
              initialQuery: ultimaConsulta,
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
    if (state is SearchInitialState) {
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
    }

    if (state is SearchingState) {
      return const CoinLoadingIndicator(itemCount: 5);
    }

    if (state is SearchSuccessState) {
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
    }

    if (state is SearchEmptyState) {
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
    }

    if (state is SearchErrorState) {
      return ErrorMessage(
        message: state.mensagemErro,
        onRetry: () {
          if (state.ultimaConsulta.isNotEmpty) {
            viewModel.pesquisarMoedas(state.ultimaConsulta);
          }
        },
      );
    }

    return const SizedBox.shrink();
  }
}
