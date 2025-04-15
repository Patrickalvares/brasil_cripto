import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/error_message.dart';
import '../../core/common_widgets/loading_indicator.dart';
import '../../domain/entities/coin.dart';
import 'components/index.dart';
import 'market_state.dart';
import 'market_viewmodel.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends StatefulBaseState<MarketView, MarketViewModel> {
  late MarketScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = MarketScrollController(viewModel);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.carregarMoedas();
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

        List<Coin> moedas = [];
        bool isLoading = false;

        if (state is MarketLoadedState) {
          moedas = state.moedas;
          isLoading = false;
        } else if (state is MarketLoadingState) {
          moedas = state.moedas;
          isLoading = true;
        } else if (state is MarketErrorState) {
          moedas = state.moedas;
          isLoading = false;
        }

        if (moedas.isEmpty) {
          return const MarketEmpty();
        }

        return MarketList(
          coins: moedas,
          isLoading: isLoading,
          scrollController: _scrollController.scrollController,
          viewModel: viewModel,
          onRefresh: () => viewModel.atualizarMoedas(),
        );
      },
    );
  }
}
