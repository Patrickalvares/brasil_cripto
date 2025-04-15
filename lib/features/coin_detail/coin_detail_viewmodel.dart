import 'package:flutter/foundation.dart';

import '../../domain/repositories/coin_repository.dart';
import 'coin_detail_state.dart';

class CoinDetailViewModel extends ChangeNotifier {
  final CoinRepository _repository;
  
  CoinDetailState _state = const CoinDetailState();
  
  CoinDetailState get state => _state;
  
  CoinDetailViewModel(this._repository);
  
  Future<void> carregarDetalhesMoeda(String id) async {
    _state = _state.copyWith(status: DetailStatus.carregando);
    notifyListeners();
    
    try {
      final detalhe = await _repository.getCoinDetail(id);
      _state = _state.copyWith(
        status: DetailStatus.carregado,
        detalheMoeda: detalhe,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: DetailStatus.erro,
        mensagemErro: e.toString(),
      );
    }
    
    notifyListeners();
  }
  
  Future<void> alternarFavorito() async {
    if (_state.detalheMoeda == null) return;
    
    try {
      if (_state.eFavorito) {
        await _repository.removeFromFavorites(_state.detalheMoeda!.id);
        _state = _state.copyWith(
          detalheMoeda: _state.detalheMoeda!.copyWith(isFavorite: false),
        );
      } else {
        await _repository.addToFavorites(_state.detalheMoeda!.id);
        _state = _state.copyWith(
          detalheMoeda: _state.detalheMoeda!.copyWith(isFavorite: true),
        );
      }
      
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(mensagemErro: e.toString());
      notifyListeners();
    }
  }
} 
