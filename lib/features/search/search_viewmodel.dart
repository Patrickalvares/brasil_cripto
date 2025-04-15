import 'package:brasil_cripto/utils/base_notifier.dart';

import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';
import 'search_state.dart';

class SearchViewModel extends BaseNotifier<SearchState> {
  final CoinRepository _repository;

  SearchViewModel({required CoinRepository repository})
    : _repository = repository,
      super(SearchInitialState());

  Future<void> pesquisarMoedas(String consulta) async {
    if (consulta.isEmpty) {
      emit(SearchInitialState());
      return;
    }

    final state = currentState;
    if (state is SearchSuccessState && consulta == state.ultimaConsulta) return;
    if (state is SearchingState && consulta == state.ultimaConsulta) return;
    if (state is SearchErrorState && consulta == state.ultimaConsulta) return;
    if (state is SearchEmptyState && consulta == state.ultimaConsulta) return;

    emit(SearchingState(ultimaConsulta: consulta));

    try {
      final resultados = await _repository.searchCoins(consulta);

      if (resultados.isEmpty) {
        emit(SearchEmptyState(ultimaConsulta: consulta));
      } else {
        emit(SearchSuccessState(resultados: resultados, ultimaConsulta: consulta));
      }
    } catch (e) {
      emit(SearchErrorState(mensagemErro: e.toString(), ultimaConsulta: consulta));
    }
  }

  Future<void> alternarFavorito(String moedaId) async {
    final state = currentState;
    if (state is! SearchSuccessState) return;

    final index = state.resultados.indexWhere((moeda) => moeda.id == moedaId);
    if (index == -1) return;

    final moeda = state.resultados[index];
    final novosResultados = List<Coin>.from(state.resultados);

    if (moeda.isFavorite) {
      await _repository.removeFromFavorites(moedaId);
      novosResultados[index] = moeda.copyWith(isFavorite: false);
    } else {
      await _repository.addToFavorites(moedaId);
      novosResultados[index] = moeda.copyWith(isFavorite: true);
    }

    emit(SearchSuccessState(resultados: novosResultados, ultimaConsulta: state.ultimaConsulta));
  }

  void limparPesquisa() {
    emit(SearchInitialState());
  }
}
