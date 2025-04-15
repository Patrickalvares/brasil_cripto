import '../../domain/entities/coin.dart';

abstract class MarketState {}

class MarketInitialState extends MarketState {}

class MarketLoadingState extends MarketState {
  final List<Coin> moedas;

  MarketLoadingState({this.moedas = const []});
}

class MarketLoadedState extends MarketState {
  final List<Coin> moedas;

  MarketLoadedState({this.moedas = const []});

  MarketLoadedState copyWith({List<Coin>? moedas}) {
    return MarketLoadedState(moedas: moedas ?? this.moedas);
  }
}

class MarketErrorState extends MarketState {
  final List<Coin> moedas;
  final String mensagemErro;

  MarketErrorState({this.moedas = const [], this.mensagemErro = ''});
}
