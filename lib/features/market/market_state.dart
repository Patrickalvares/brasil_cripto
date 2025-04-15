import '../../domain/entities/coin.dart';

class MarketState {}

class MarketInitialState extends MarketState {}

class MarketLoadingState extends MarketState {
  final List<Coin> moedas;
  final int paginaAtual;
  final bool temMaisDados;

  MarketLoadingState({this.moedas = const [], this.paginaAtual = 1, this.temMaisDados = true});
}

class MarketLoadedState extends MarketState {
  final List<Coin> moedas;
  final int paginaAtual;
  final bool temMaisDados;

  MarketLoadedState({this.moedas = const [], this.paginaAtual = 1, this.temMaisDados = true});

  MarketLoadedState copyWith({List<Coin>? moedas, int? paginaAtual, bool? temMaisDados}) {
    return MarketLoadedState(
      moedas: moedas ?? this.moedas,
      paginaAtual: paginaAtual ?? this.paginaAtual,
      temMaisDados: temMaisDados ?? this.temMaisDados,
    );
  }
}

class MarketErrorState extends MarketState {
  final List<Coin> moedas;
  final String mensagemErro;
  final int paginaAtual;
  final bool temMaisDados;

  MarketErrorState({
    this.moedas = const [],
    this.mensagemErro = '',
    this.paginaAtual = 1,
    this.temMaisDados = true,
  });
}
