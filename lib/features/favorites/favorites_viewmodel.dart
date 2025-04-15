import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/repositories/coin_repository.dart';
import 'favorites_state.dart';

class FavoritesViewModel extends BaseNotifier<FavoritesState> {
  final CoinRepository _repository;

  FavoritesViewModel({required CoinRepository repository})
    : _repository = repository,
      super(FavoritesInitialState());

  Future<void> carregarFavoritos() async {
    emit(FavoritesLoadingState());

    try {
      final favoritos = await _repository.getFavoriteCoins();

      if (favoritos.isEmpty) {
        emit(FavoritesEmptyState());
      } else {
        emit(FavoritesLoadedState(moedasFavoritas: favoritos));
      }
    } catch (e) {
      emit(FavoritesErrorState(mensagemErro: e.toString()));
    }
  }

  Future<void> removerDosFavoritos(String moedaId) async {
    final state = currentState;

    if (state is! FavoritesLoadedState) return;

    await _repository.removeFromFavorites(moedaId);

    final novasMoedas = state.moedasFavoritas.where((moeda) => moeda.id != moedaId).toList();

    if (novasMoedas.isEmpty) {
      emit(FavoritesEmptyState());
    } else {
      emit(FavoritesLoadedState(moedasFavoritas: novasMoedas));
    }
  }

  Future<bool> eFavorito(String moedaId) async {
    return await _repository.isFavorite(moedaId);
  }
}
