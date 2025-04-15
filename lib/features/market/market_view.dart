import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/coin_list_item.dart';
import '../../core/common_widgets/error_message.dart';
import '../../core/common_widgets/loading_indicator.dart';
import '../coin_detail/coin_detail_view.dart';
import 'market_state.dart';
import 'market_viewmodel.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends StatefulBaseState<MarketView, MarketViewModel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.carregarMoedas();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final currentState = viewModel.currentState;

        final bool isLoading = currentState is MarketLoadingState;
        final bool hasMoreData =
            currentState is MarketLoadedState
                ? currentState.temMaisDados
                : (currentState is MarketErrorState ? currentState.temMaisDados : false);

        if (!isLoading && hasMoreData) {
          viewModel.carregarMoedas();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (_, state, __) {
        if (state is MarketInitialState) {
          return const CoinLoadingIndicator();
        }

        if (state is MarketLoadingState && state.moedas.isEmpty) {
          return const CoinLoadingIndicator();
        }

        if (state is MarketErrorState && state.moedas.isEmpty) {
          return ErrorMessage(
            message: state.mensagemErro,
            onRetry: () => viewModel.atualizarMoedas(),
          );
        }

        List<dynamic> moedas = [];
        bool temMaisDados = false;
        bool isLoading = false;

        if (state is MarketLoadedState) {
          moedas = state.moedas;
          temMaisDados = state.temMaisDados;
          isLoading = false;
        } else if (state is MarketLoadingState) {
          moedas = state.moedas;
          temMaisDados = state.temMaisDados;
          isLoading = true;
        } else if (state is MarketErrorState) {
          moedas = state.moedas;
          temMaisDados = state.temMaisDados;
          isLoading = false;
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.atualizarMoedas(),
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: moedas.length + (temMaisDados || isLoading ? 1 : 0),
            separatorBuilder:
                (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              if (index == moedas.length) {
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

              final moeda = moedas[index];
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
      },
    );
  }
}
