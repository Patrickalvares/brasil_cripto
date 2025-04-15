import 'package:brasil_cripto/core/constants/api_constants.dart';

import '../../core/services/storage_service.dart';
import '../../domain/entities/coin.dart';
import '../../domain/entities/coin_detail.dart';
import '../../domain/repositories/coin_repository.dart';
import '../datasources/coin_data_source.dart';

class CoinRepositoryImpl implements ICoinRepository {
  final ICoinDataSource _dataSource;
  final StorageService _storageService;

  CoinRepositoryImpl(this._dataSource, this._storageService);

  @override
  Future<List<Coin>> getCoins({
    String currency = ApiConstants.defaultCurrency,
    int page = 1,
    int perPage = 20,
    bool sparkline = false,
  }) async {
    final coins = await _dataSource.getCoins(
      currency: currency,
      page: page,
      perPage: perPage,
      sparkline: sparkline,
    );

    final favoriteIds = await _storageService.getFavoriteCoins();
    return coins.map((coin) {
      if (favoriteIds.contains(coin.id)) {
        return coin.copyWith(isFavorite: true);
      }
      return coin;
    }).toList();
  }

  @override
  Future<List<Coin>> searchCoins(String query) async {
    final coins = await _dataSource.searchCoins(query);

    final favoriteIds = await _storageService.getFavoriteCoins();
    return coins.map((coin) {
      if (favoriteIds.contains(coin.id)) {
        return coin.copyWith(isFavorite: true);
      }
      return coin;
    }).toList();
  }

  @override
  Future<CoinDetail> getCoinDetail(String id) async {
    final coinDetail = await _dataSource.getCoinDetail(id);

    final isFavorite = await _storageService.isFavoriteCoin(id);
    return coinDetail.copyWith(isFavorite: isFavorite);
  }

  @override
  Future<void> addToFavorites(String coinId) async {
    await _storageService.addFavoriteCoin(coinId);
  }

  @override
  Future<void> removeFromFavorites(String coinId) async {
    await _storageService.removeFavoriteCoin(coinId);
  }

  @override
  Future<bool> isFavorite(String coinId) async {
    return await _storageService.isFavoriteCoin(coinId);
  }

  @override
  Future<List<Coin>> getFavoriteCoins() async {
    final favoriteIds = await _storageService.getFavoriteCoins();

    if (favoriteIds.isEmpty) {
      return [];
    }

    List<Coin> favoriteCoins = [];

    for (var id in favoriteIds) {
      try {
        final coin = await _dataSource.getCoinDetail(id);
        favoriteCoins.add(coin.copyWith(isFavorite: true));
      } catch (e) {
        continue;
      }
    }

    return favoriteCoins;
  }
}
