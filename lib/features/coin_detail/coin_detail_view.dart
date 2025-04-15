import 'package:brasil_cripto/utils/state_ful_base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/common_widgets/error_message.dart';
import 'coin_detail_state.dart';
import 'coin_detail_viewmodel.dart';
import 'components/index.dart';

class CoinDetailView extends StatefulWidget {
  final String coinId;

  const CoinDetailView({super.key, required this.coinId});

  @override
  State<CoinDetailView> createState() => _CoinDetailViewState();
}

class _CoinDetailViewState extends StatefulBaseState<CoinDetailView, CoinDetailViewModel> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.carregarDetalhesMoeda(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('coin_details'.tr()),
        actions: [
          ValueListenableBuilder(
            valueListenable: viewModel,
            builder: (_, state, __) {
              if (state is CoinDetailLoadedState) {
                return IconButton(
                  icon: Icon(
                    state.eFavorito ? Icons.star : Icons.star_border,
                    color: state.eFavorito ? Colors.amber : null,
                  ),
                  onPressed: () {
                    viewModel.alternarFavorito();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: viewModel,
        builder: (_, state, __) {
          if (state is CoinDetailErrorState) {
            return ErrorMessage(
              message: state.mensagemErro,
              onRetry: () => viewModel.carregarDetalhesMoeda(widget.coinId),
            );
          }
          if (state is CoinDetailLoadedState) {
            final moeda = (state).detalheMoeda!;
            return RefreshIndicator(
              onRefresh: () => viewModel.carregarDetalhesMoeda(widget.coinId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CoinHeader(name: moeda.name, symbol: moeda.symbol, imageUrl: moeda.image),
                      const SizedBox(height: 32),
                      PriceInfo(
                        currentPrice: moeda.currentPrice,
                        priceChangePercentage24h: moeda.priceChangePercentage24h,
                      ),
                      const SizedBox(height: 32),
                      PriceChart(
                        sparklineData: moeda.sparklineData,
                        priceChangePercentage24h: moeda.priceChangePercentage24h,
                      ),
                      const SizedBox(height: 32),
                      MarketStats(
                        marketCap: moeda.marketCap,
                        totalVolume: moeda.totalVolume,
                        marketCapRank: moeda.marketCapRank,
                        high24h: moeda.high24h,
                        low24h: moeda.low24h,
                      ),
                      const SizedBox(height: 24),
                      CoinDescription(coinName: moeda.name, description: moeda.description),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
