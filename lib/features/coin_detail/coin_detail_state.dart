import '../../domain/entities/coin_detail.dart';

enum DetailStatus { inicial, carregando, carregado, erro }

class CoinDetailState {
  final DetailStatus status;
  final CoinDetail? detalheMoeda;
  final String mensagemErro;

  const CoinDetailState({
    this.status = DetailStatus.inicial,
    this.detalheMoeda,
    this.mensagemErro = '',
  });

  bool get eFavorito => detalheMoeda?.isFavorite ?? false;

  CoinDetailState copyWith({
    DetailStatus? status,
    CoinDetail? detalheMoeda,
    String? mensagemErro,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      detalheMoeda: detalheMoeda ?? this.detalheMoeda,
      mensagemErro: mensagemErro ?? this.mensagemErro,
    );
  }
} 
