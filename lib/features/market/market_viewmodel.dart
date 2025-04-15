import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';
import 'market_state.dart';

class MarketViewModel extends BaseNotifier<MarketState> {
  final CoinRepository _repository;

  MarketState _state = const MarketState();

  MarketViewModel({required CoinRepository repository})
    : _repository = repository,
      super(const MarketState());

  MarketState get state => _state;

  Future<void> carregarMoedas({bool atualizar = false}) async {
    if (atualizar) {
      _state = _state.copyWith(moedas: [], paginaAtual: 1, temMaisDados: true);
    }

    if (_state.status == MarketStatus.carregando || (!_state.temMaisDados && !atualizar)) {
      return;
    }

    _state = _state.copyWith(status: MarketStatus.carregando);
    notifyListeners();

    try {
      final novasMoedas = await _repository.getCoins(
        page: _state.paginaAtual,
        perPage: 20,
        sparkline: true,
      );

      if (novasMoedas.isEmpty) {
        _state = _state.copyWith(temMaisDados: false);
      } else {
        final moedasAtualizadas = [..._state.moedas, ...novasMoedas];
        _state = _state.copyWith(
          moedas: moedasAtualizadas,
          paginaAtual: _state.paginaAtual + 1,
          status: MarketStatus.carregado,
        );
      }
    } catch (e) {
      _state = _state.copyWith(status: MarketStatus.erro, mensagemErro: e.toString());
    }

    notifyListeners();
  }

  Future<void> atualizarMoedas() async {
    await carregarMoedas(atualizar: true);
  }

  Future<void> alternarFavorito(String moedaId) async {
    final index = _state.moedas.indexWhere((moeda) => moeda.id == moedaId);
    if (index == -1) return;

    final moeda = _state.moedas[index];
    final novasMoedas = List<Coin>.from(_state.moedas);

    if (moeda.isFavorite) {
      await _repository.removeFromFavorites(moedaId);
      novasMoedas[index] = moeda.copyWith(isFavorite: false);
      _state = _state.copyWith(moedas: novasMoedas);
    } else {
      await _repository.addToFavorites(moedaId);
      novasMoedas[index] = moeda.copyWith(isFavorite: true);
      _state = _state.copyWith(moedas: novasMoedas);
    }

    notifyListeners();
  }
}
