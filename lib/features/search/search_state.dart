import '../../domain/entities/coin.dart';

class SearchState {}

class SearchInitialState extends SearchState {}

class SearchingState extends SearchState {
  final String ultimaConsulta;

  SearchingState({this.ultimaConsulta = ''});
}

class SearchSuccessState extends SearchState {
  final List<Coin> resultados;
  final String ultimaConsulta;

  SearchSuccessState({this.resultados = const [], this.ultimaConsulta = ''});

  SearchSuccessState copyWith({List<Coin>? resultados, String? ultimaConsulta}) {
    return SearchSuccessState(
      resultados: resultados ?? this.resultados,
      ultimaConsulta: ultimaConsulta ?? this.ultimaConsulta,
    );
  }
}

class SearchErrorState extends SearchState {
  final String mensagemErro;
  final String ultimaConsulta;

  SearchErrorState({this.mensagemErro = '', this.ultimaConsulta = ''});
}

class SearchEmptyState extends SearchState {
  final String ultimaConsulta;

  SearchEmptyState({this.ultimaConsulta = ''});
}
