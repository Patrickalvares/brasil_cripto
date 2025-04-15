import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _MarketViewState extends State<MarketView> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketViewModel>().carregarMoedas();
    });
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final viewModel = context.read<MarketViewModel>();
        final state = viewModel.state;
        if (state.status != MarketStatus.carregando && state.temMaisDados) {
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
    return Consumer<MarketViewModel>(
      builder: (context, viewModel, _) {
        final state = viewModel.state;
        
        if (state.status == MarketStatus.inicial) {
          return const CoinLoadingIndicator();
        }
        
        if (state.status == MarketStatus.erro && state.moedas.isEmpty) {
          return ErrorMessage(
            message: state.mensagemErro,
            onRetry: () => viewModel.atualizarMoedas(),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => viewModel.atualizarMoedas(),
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.moedas.length + (state.temMaisDados ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              if (index == state.moedas.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              final moeda = state.moedas[index];
              return CoinListItem(
                coin: moeda,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoinDetailView(coinId: moeda.id),
                    ),
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
