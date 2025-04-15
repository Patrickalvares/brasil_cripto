import '../../domain/entities/coin.dart';

enum MarketStatus { inicial, carregando, carregado, erro }

class MarketState {
  final MarketStatus status;
  final List<Coin> moedas;
  final String mensagemErro;
  final int paginaAtual;
  final bool temMaisDados;

  const MarketState({
    this.status = MarketStatus.inicial,
    this.moedas = const [],
    this.mensagemErro = '',
    this.paginaAtual = 1,
    this.temMaisDados = true,
  });

  MarketState copyWith({
    MarketStatus? status,
    List<Coin>? moedas,
    String? mensagemErro,
    int? paginaAtual,
    bool? temMaisDados,
  }) {
    return MarketState(
      status: status ?? this.status,
      moedas: moedas ?? this.moedas,
      mensagemErro: mensagemErro ?? this.mensagemErro,
      paginaAtual: paginaAtual ?? this.paginaAtual,
      temMaisDados: temMaisDados ?? this.temMaisDados,
    );
  }
} 
