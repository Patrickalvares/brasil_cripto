import 'package:brasil_cripto/core/common_widgets/loading_indicator.dart';
import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/error_message.dart';
import 'components/index.dart';
import 'favorites_state.dart';
import 'favorites_viewmodel.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends StatefulBaseState<FavoritesView, FavoritesViewModel> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.carregarFavoritos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (_, state, __) {
        if (state is FavoritesErrorState) {
          return ErrorMessage(
            message: state.mensagemErro,
            onRetry: () => viewModel.carregarFavoritos(),
          );
        }

        if (state is FavoritesEmptyState) {
          return const EmptyFavorites();
        }

        if (state is FavoritesLoadedState) {
          return FavoritesList(
            coins: state.moedasFavoritas,
            viewModel: viewModel,
            onRefresh: () => viewModel.carregarFavoritos(),
          );
        }

        return const CoinLoadingIndicator();
      },
    );
  }
}
