import 'package:flutter/foundation.dart';

import '../../domain/entities/coin.dart';
import '../../domain/repositories/coin_repository.dart';
import 'search_state.dart';

class SearchViewModel extends ChangeNotifier {
  final CoinRepository _repository;
  
  SearchState _state = const SearchState();
  
  SearchState get state => _state;
  
  SearchViewModel(this._repository);
  
  Future<void> pesquisarMoedas(String consulta) async {
    if (consulta.isEmpty) {
      _state = _state.copyWith(status: SearchStatus.inicial, resultados: []);
      notifyListeners();
      return;
    }
    
    if (consulta == _state.ultimaConsulta) return;
    
    _state = _state.copyWith(
      status: SearchStatus.pesquisando,
      ultimaConsulta: consulta,
    );
    notifyListeners();
    
    try {
      final resultados = await _repository.searchCoins(consulta);
      
      if (resultados.isEmpty) {
        _state = _state.copyWith(status: SearchStatus.vazio);
      } else {
        _state = _state.copyWith(
          status: SearchStatus.sucesso,
          resultados: resultados,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        status: SearchStatus.erro,
        mensagemErro: e.toString(),
      );
    }
    
    notifyListeners();
  }
  
  Future<void> alternarFavorito(String moedaId) async {
    final index = _state.resultados.indexWhere((moeda) => moeda.id == moedaId);
    if (index == -1) return;
    
    final moeda = _state.resultados[index];
    final novosResultados = List<Coin>.from(_state.resultados);
    
    if (moeda.isFavorite) {
      await _repository.removeFromFavorites(moedaId);
      novosResultados[index] = moeda.copyWith(isFavorite: false);
    } else {
      await _repository.addToFavorites(moedaId);
      novosResultados[index] = moeda.copyWith(isFavorite: true);
    }
    
    _state = _state.copyWith(resultados: novosResultados);
    notifyListeners();
  }
  
  void limparPesquisa() {
    _state = const SearchState();
    notifyListeners();
  }
} 
