import '../../domain/entities/coin.dart';

class CoinModel extends Coin {
  CoinModel({
    required super.id,
    required super.symbol,
    required super.name,
    super.image,
    super.currentPrice,
    super.marketCap,
    super.marketCapRank,
    super.priceChangePercentage24h,
    super.high24h,
    super.low24h,
    super.totalVolume,
    super.sparklineData,
    super.isFavorite,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      currentPrice: json['current_price']?.toDouble(),
      marketCap: json['market_cap']?.toDouble(),
      marketCapRank: json['market_cap_rank'],
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble(),
      high24h: json['high_24h']?.toDouble(),
      low24h: json['low_24h']?.toDouble(),
      totalVolume: json['total_volume']?.toDouble(),
      sparklineData: json['sparkline_in_7d'] != null && json['sparkline_in_7d']['price'] != null
          ? List<double>.from(json['sparkline_in_7d']['price'].map((x) => x.toDouble()))
          : null,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_percentage_24h': priceChangePercentage24h,
      'high_24h': high24h,
      'low_24h': low24h,
      'total_volume': totalVolume,
      'sparkline_in_7d': sparklineData != null ? {'price': sparklineData} : null,
    };
  }
  
  factory CoinModel.fromSearchResult(Map<String, dynamic> json, {bool isFavorite = false}) {
    return CoinModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      marketCapRank: json['market_cap_rank'],
      image: json['large'] ?? json['thumb'],
      isFavorite: isFavorite,
    );
  }
} 
