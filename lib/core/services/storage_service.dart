import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoriteCoinsKey = 'favorite_coins';
  
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();
  
  // Salva uma lista de IDs de moedas nos favoritos
  Future<bool> saveFavoriteCoins(List<String> coinIds) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setStringList(_favoriteCoinsKey, coinIds);
  }
  
  // Adiciona um único ID de moeda aos favoritos
  Future<bool> addFavoriteCoin(String coinId) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = await getFavoriteCoins();
    
    if (!favorites.contains(coinId)) {
      favorites.add(coinId);
      return await prefs.setStringList(_favoriteCoinsKey, favorites);
    }
    
    return true;
  }
  
  // Remove um ID de moeda dos favoritos
  Future<bool> removeFavoriteCoin(String coinId) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = await getFavoriteCoins();
    
    if (favorites.contains(coinId)) {
      favorites.remove(coinId);
      return await prefs.setStringList(_favoriteCoinsKey, favorites);
    }
    
    return true;
  }
  
  // Obtém todos os IDs de moedas favoritas
  Future<List<String>> getFavoriteCoins() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(_favoriteCoinsKey) ?? [];
  }
  
  // Verifica se uma moeda está nos favoritos
  Future<bool> isFavoriteCoin(String coinId) async {
    final List<String> favorites = await getFavoriteCoins();
    return favorites.contains(coinId);
  }
} 
