import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/repositories/coin_repository.dart';
import 'coin_detail_state.dart';

class CoinDetailViewModel extends BaseNotifier<CoinDetailState> {
  final CoinRepository _repository;

  CoinDetailViewModel({required CoinRepository repository})
    : _repository = repository,
      super(CoinDetailInitialState());

  Future<void> carregarDetalhesMoeda(String id) async {
    emit(CoinDetailLoadingState());

    try {
      final detalhe = await _repository.getCoinDetail(id);
      emit(CoinDetailLoadedState(detalheMoeda: detalhe));
    } catch (e) {
      emit(CoinDetailErrorState(mensagemErro: e.toString()));
    }
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
