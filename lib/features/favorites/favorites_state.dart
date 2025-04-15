import '../../domain/entities/coin.dart';

class FavoritesState {}

class FavoritesInitialState extends FavoritesState {}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<Coin> moedasFavoritas;

  FavoritesLoadedState({this.moedasFavoritas = const []});

  FavoritesLoadedState copyWith({List<Coin>? moedasFavoritas}) {
    return FavoritesLoadedState(moedasFavoritas: moedasFavoritas ?? this.moedasFavoritas);
  }
}

class FavoritesErrorState extends FavoritesState {
  final String mensagemErro;
  final List<Coin> moedasFavoritas;

  FavoritesErrorState({this.mensagemErro = '', this.moedasFavoritas = const []});
}

class FavoritesEmptyState extends FavoritesState {}
