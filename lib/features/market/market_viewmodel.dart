import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../core/services/currency_provider.dart';
import '../../core/services/injections.dart';
import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';
import 'market_state.dart';

class MarketViewModel extends BaseNotifier<MarketState> {
  final ICoinRepository _repository;
  final CurrencyProvider _currencyProvider;

  MarketViewModel({required ICoinRepository repository})
    : _repository = repository,
      _currencyProvider = i<CurrencyProvider>(),
      super(MarketInitialState()) {
    _currencyProvider.addListener(_onCurrencyChanged);
  }

  @override
  void dispose() {
    _currencyProvider.removeListener(_onCurrencyChanged);
    super.dispose();
  }

  void _onCurrencyChanged() {
    atualizarMoedas();
  }

  Future<void> carregarMoedas({bool atualizar = false}) async {
    if (currentState is MarketLoadingState && !atualizar) {
      return;
    }

    emit(MarketLoadingState(moedas: []));

    try {
      final moedas = await _repository.getCoins(
        currency: _currencyProvider.currency,
        page: 1,
        perPage: 20,
        sparkline: true,
      );

      emit(MarketLoadedState(moedas: moedas));
    } catch (e) {
      emit(MarketErrorState(moedas: [], mensagemErro: e.toString()));
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
      emit(MarketLoadedState(moedas: novasMoedas));
    } else if (state is MarketErrorState) {
      emit(MarketErrorState(moedas: novasMoedas, mensagemErro: state.mensagemErro));
    }
  }
}
