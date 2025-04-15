import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../models/coin_detail_model.dart';
import '../models/coin_model.dart';

abstract class CoinDataSource {
  Future<List<CoinModel>> getCoins({
    String currency = 'usd',
    int page = 1,
    int perPage = 20,
    bool sparkline = false,
  });

  Future<List<CoinModel>> searchCoins(String query);
  
  Future<CoinDetailModel> getCoinDetail(String id);
}

class CoinDataSourceImpl implements CoinDataSource {
  final ApiService _apiService;

  CoinDataSourceImpl(this._apiService);

  @override
  Future<List<CoinModel>> getCoins({
    String currency = 'usd',
    int page = 1,
    int perPage = 20,
    bool sparkline = false,
  }) async {
    try {
      final queryParams = {
        ApiConstants.vsCurrency: currency,
        ApiConstants.page: page,
        ApiConstants.perPage: perPage,
        ApiConstants.order: ApiConstants.defaultOrder,
        'sparkline': sparkline,
      };

      final response = await _apiService.get(ApiConstants.markets, queryParams: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> coinListJson = response.data;
        return coinListJson.map((json) => CoinModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coins');
      }
    } catch (e) {
      throw Exception('Failed to load coins: $e');
    }
  }

  @override
  Future<List<CoinModel>> searchCoins(String query) async {
    try {
      final queryParams = {
        ApiConstants.query: query,
      };

      final response = await _apiService.get(ApiConstants.search, queryParams: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> coinListJson = response.data['coins'] ?? [];
        return coinListJson.map((json) => CoinModel.fromSearchResult(json)).toList();
      } else {
        throw Exception('Failed to search coins');
      }
    } catch (e) {
      throw Exception('Failed to search coins: $e');
    }
  }

  @override
  Future<CoinDetailModel> getCoinDetail(String id) async {
    try {
      final queryParams = {
        'localization': false,
        'tickers': true,
        'market_data': true,
        'community_data': true,
        'developer_data': true,
      };

      final response = await _apiService.get('${ApiConstants.coins}/$id', queryParams: queryParams);
      
      if (response.statusCode == 200) {
        return CoinDetailModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load coin detail');
      }
    } catch (e) {
      throw Exception('Failed to load coin detail: $e');
    }
  }
} 
