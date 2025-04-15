import '../entities/coin.dart';
import '../entities/coin_detail.dart';

abstract class CoinRepository {
  Future<List<Coin>> getCoins({
    String currency = 'usd',
    int page = 1,
    int perPage = 20,
    bool sparkline = false,
  });
  
  Future<List<Coin>> searchCoins(String query);
  
  Future<CoinDetail> getCoinDetail(String id);
  
  Future<void> addToFavorites(String coinId);
  
  Future<void> removeFromFavorites(String coinId);
  
  Future<bool> isFavorite(String coinId);
  
  Future<List<Coin>> getFavoriteCoins();
} 
