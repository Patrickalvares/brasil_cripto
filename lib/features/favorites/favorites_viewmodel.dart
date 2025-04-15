import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/repositories/coin_repository.dart';
import 'favorites_state.dart';

class FavoritesViewModel extends BaseNotifier<FavoritesState> {
  final CoinRepository _repository;

  FavoritesState _state = const FavoritesState();

  FavoritesState get state => _state;

  FavoritesViewModel({required CoinRepository repository})
    : _repository = repository,
      super(const FavoritesState());

  Future<void> carregarFavoritos() async {
    _state = _state.copyWith(status: FavoritesStatus.carregando);
    notifyListeners();

    try {
      final favoritos = await _repository.getFavoriteCoins();

      if (favoritos.isEmpty) {
        _state = _state.copyWith(status: FavoritesStatus.vazio);
      } else {
        _state = _state.copyWith(status: FavoritesStatus.carregado, moedasFavoritas: favoritos);
      }
    } catch (e) {
      _state = _state.copyWith(status: FavoritesStatus.erro, mensagemErro: e.toString());
    }

    notifyListeners();
  }

  Future<void> removerDosFavoritos(String moedaId) async {
    await _repository.removeFromFavorites(moedaId);

    final novasMoedas = _state.moedasFavoritas.where((moeda) => moeda.id != moedaId).toList();

    if (novasMoedas.isEmpty) {
      _state = _state.copyWith(status: FavoritesStatus.vazio, moedasFavoritas: novasMoedas);
    } else {
      _state = _state.copyWith(moedasFavoritas: novasMoedas);
    }

    notifyListeners();
  }

  Future<bool> eFavorito(String moedaId) async {
    return await _repository.isFavorite(moedaId);
  }
}
