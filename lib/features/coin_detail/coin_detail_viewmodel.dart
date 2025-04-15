import 'dart:math';

import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/repositories/coin_repository.dart';
import 'coin_detail_state.dart';

class CoinDetailViewModel extends BaseNotifier<CoinDetailState> {
  final ICoinRepository _repository;

  CoinDetailViewModel({required ICoinRepository repository})
    : _repository = repository,
      super(CoinDetailInitialState());

  Future<void> carregarDetalhesMoeda(String id) async {
    emit(CoinDetailLoadingState());

    try {
      final detalhe = await _repository.getCoinDetail(id);

      if (detalhe.sparklineData == null || detalhe.sparklineData!.isEmpty) {
        final sparklineSimulado = _gerarDadosSparklineSimulados(detalhe.currentPrice ?? 1000.0);
        emit(
          CoinDetailLoadedState(detalheMoeda: detalhe.copyWith(sparklineData: sparklineSimulado)),
        );
      } else {
        emit(CoinDetailLoadedState(detalheMoeda: detalhe));
      }
    } catch (e) {
      emit(CoinDetailErrorState(mensagemErro: e.toString()));
    }
  }

  List<double> _gerarDadosSparklineSimulados(double precoBase) {
    final random = Random();
    final sparklineData = <double>[];

    for (var i = 0; i < 168; i++) {
      final variacao = (random.nextDouble() - 0.5) * 0.1;
      final preco = precoBase * (1 + variacao);
      sparklineData.add(preco);
    }

    return sparklineData;
  }

  Future<void> alternarFavorito() async {
    final state = currentState;
    if (state is! CoinDetailLoadedState || state.detalheMoeda == null) return;

    try {
      if (state.eFavorito) {
        await _repository.removeFromFavorites(state.detalheMoeda!.id);
        emit(CoinDetailLoadedState(detalheMoeda: state.detalheMoeda!.copyWith(isFavorite: false)));
      } else {
        await _repository.addToFavorites(state.detalheMoeda!.id);
        emit(CoinDetailLoadedState(detalheMoeda: state.detalheMoeda!.copyWith(isFavorite: true)));
      }
    } catch (e) {
      emit(CoinDetailErrorState(mensagemErro: e.toString()));
    }
  }
}
