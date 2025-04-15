import '../../domain/entities/coin.dart';

enum FavoritesStatus { inicial, carregando, carregado, erro, vazio }

class FavoritesState {
  final FavoritesStatus status;
  final List<Coin> moedasFavoritas;
  final String mensagemErro;

  const FavoritesState({
    this.status = FavoritesStatus.inicial,
    this.moedasFavoritas = const [],
    this.mensagemErro = '',
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Coin>? moedasFavoritas,
    String? mensagemErro,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      moedasFavoritas: moedasFavoritas ?? this.moedasFavoritas,
      mensagemErro: mensagemErro ?? this.mensagemErro,
    );
  }
} 
