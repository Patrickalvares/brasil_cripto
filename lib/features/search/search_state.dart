import '../../domain/entities/coin.dart';

class SearchState {}

class SearchInitialState extends SearchState {}

class SearchingState extends SearchState {
  final String ultimaConsulta;

  SearchingState({this.ultimaConsulta = ''});
}

class SearchLoadedState extends SearchState {
  final List<Coin> resultados;
  final String ultimaConsulta;

  SearchLoadedState({this.resultados = const [], this.ultimaConsulta = ''});

  SearchLoadedState copyWith({List<Coin>? resultados, String? ultimaConsulta}) {
    return SearchLoadedState(
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
