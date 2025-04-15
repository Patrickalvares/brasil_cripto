import 'package:brasil_cripto/core/common_widgets/loading_indicator.dart';
import 'package:brasil_cripto/core/common_widgets/search_bar_widget.dart';
import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/error_message.dart';
import 'components/index.dart';
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
        } else if (state is SearchLoadedState) {
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
              onSearch: (query) => viewModel.pesquisarMoedas(query),
              onClear: () => viewModel.limparPesquisa(),
            ),
            Expanded(child: _buildResultadosPesquisa(state)),
          ],
        );
      },
    );
  }

  Widget _buildResultadosPesquisa(SearchState state) {
    if (state is SearchInitialState) {
      return const SearchInitial();
    }

    if (state is SearchLoadedState) {
      return SearchResults(coins: state.resultados, viewModel: viewModel);
    }

    if (state is SearchEmptyState) {
      return const SearchEmpty();
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

    return const CoinLoadingIndicator(itemCount: 5);
  }
}
