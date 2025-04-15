import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';
import 'market_state.dart';

class MarketViewModel extends BaseNotifier<MarketState> {
  final CoinRepository _repository;

  MarketViewModel({required CoinRepository repository})
    : _repository = repository,
      super(MarketInitialState());

  Future<void> carregarMoedas({bool atualizar = false}) async {
    final state = currentState;

    if (atualizar) {
      emit(MarketLoadingState(moedas: [], paginaAtual: 1, temMaisDados: true));

      try {
        final novasMoedas = await _repository.getCoins(page: 1, perPage: 20, sparkline: true);

        if (novasMoedas.isEmpty) {
          emit(MarketLoadedState(moedas: [], paginaAtual: 1, temMaisDados: false));
        } else {
          emit(MarketLoadedState(moedas: novasMoedas, paginaAtual: 2, temMaisDados: true));
        }
      } catch (e) {
        emit(
          MarketErrorState(
            moedas: [],
            mensagemErro: e.toString(),
            paginaAtual: 1,
            temMaisDados: true,
          ),
        );
      }
      return;
    }

    if (state is MarketLoadingState) {
      return;
    }

    if (state is MarketLoadedState && !state.temMaisDados) {
      return;
    }

    List<Coin> currentMoedas = [];
    int currentPage = 1;

    if (state is MarketLoadedState) {
      currentMoedas = state.moedas;
      currentPage = state.paginaAtual;
    } else if (state is MarketLoadingState) {
      currentMoedas = state.moedas;
      currentPage = state.paginaAtual;
    } else if (state is MarketErrorState) {
      currentMoedas = state.moedas;
      currentPage = state.paginaAtual;
    }

    emit(MarketLoadingState(moedas: currentMoedas, paginaAtual: currentPage, temMaisDados: true));

    try {
      final novasMoedas = await _repository.getCoins(
        page: currentPage,
        perPage: 20,
        sparkline: true,
      );

      if (novasMoedas.isEmpty) {
        emit(
          MarketLoadedState(moedas: currentMoedas, paginaAtual: currentPage, temMaisDados: false),
        );
      } else {
        final moedasAtualizadas = [...currentMoedas, ...novasMoedas];
        emit(
          MarketLoadedState(
            moedas: moedasAtualizadas,
            paginaAtual: currentPage + 1,
            temMaisDados: true,
          ),
        );
      }
    } catch (e) {
      emit(
        MarketErrorState(
          moedas: currentMoedas,
          mensagemErro: e.toString(),
          paginaAtual: currentPage,
          temMaisDados: true,
        ),
      );
    }
  }

  Future<void> atualizarMoedas() async {
    await carregarMoedas(atualizar: true);
  }

  Future<void> alternarFavorito(String moedaId) async {
    final state = currentState;
    if (state is! MarketLoadedState && state is! MarketErrorState) {
      return;
    }

    List<Coin> currentMoedas = [];
    if (state is MarketLoadedState) {
      currentMoedas = state.moedas;
    } else if (state is MarketErrorState) {
      currentMoedas = state.moedas;
    }

    final index = currentMoedas.indexWhere((moeda) => moeda.id == moedaId);
    if (index == -1) return;

    final moeda = currentMoedas[index];
    final novasMoedas = List<Coin>.from(currentMoedas);

    if (moeda.isFavorite) {
      await _repository.removeFromFavorites(moedaId);
      novasMoedas[index] = moeda.copyWith(isFavorite: false);
    } else {
      await _repository.addToFavorites(moedaId);
      novasMoedas[index] = moeda.copyWith(isFavorite: true);
    }

    if (state is MarketLoadedState) {
      emit(
        MarketLoadedState(
          moedas: novasMoedas,
          paginaAtual: state.paginaAtual,
          temMaisDados: state.temMaisDados,
        ),
      );
    } else if (state is MarketErrorState) {
      emit(
        MarketErrorState(
          moedas: novasMoedas,
          mensagemErro: state.mensagemErro,
          paginaAtual: state.paginaAtual,
          temMaisDados: state.temMaisDados,
        ),
      );
    }
  }
}
