import '../../domain/entities/coin.dart';

enum SearchStatus { inicial, pesquisando, sucesso, erro, vazio }

class SearchState {
  final SearchStatus status;
  final List<Coin> resultados;
  final String mensagemErro;
  final String ultimaConsulta;

  const SearchState({
    this.status = SearchStatus.inicial,
    this.resultados = const [],
    this.mensagemErro = '',
    this.ultimaConsulta = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Coin>? resultados,
    String? mensagemErro,
    String? ultimaConsulta,
  }) {
    return SearchState(
      status: status ?? this.status,
      resultados: resultados ?? this.resultados,
      mensagemErro: mensagemErro ?? this.mensagemErro,
      ultimaConsulta: ultimaConsulta ?? this.ultimaConsulta,
    );
  }
} 
