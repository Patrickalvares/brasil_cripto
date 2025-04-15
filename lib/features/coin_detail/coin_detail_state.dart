import '../../domain/entities/coin_detail.dart';

class CoinDetailState {}

class CoinDetailInitialState extends CoinDetailState {}

class CoinDetailLoadingState extends CoinDetailState {}

class CoinDetailLoadedState extends CoinDetailState {
  final CoinDetail? detalheMoeda;

  CoinDetailLoadedState({this.detalheMoeda});

  bool get eFavorito => detalheMoeda?.isFavorite ?? false;

  CoinDetailLoadedState copyWith({CoinDetail? detalheMoeda}) {
    return CoinDetailLoadedState(detalheMoeda: detalheMoeda ?? this.detalheMoeda);
  }
}

class CoinDetailErrorState extends CoinDetailState {
  final String mensagemErro;

  CoinDetailErrorState({this.mensagemErro = ''});
}
