import 'package:flutter/material.dart';

import '../market_state.dart';
import '../market_viewmodel.dart';

class MarketScrollController {
  final ScrollController scrollController = ScrollController();
  final MarketViewModel viewModel;

  MarketScrollController(this.viewModel) {
    _init();
  }

  void _init() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
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

  void dispose() {
    scrollController.dispose();
  }
}
