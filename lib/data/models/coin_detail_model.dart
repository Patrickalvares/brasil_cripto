import '../../domain/entities/coin_detail.dart';

class CoinDetailModel extends CoinDetail {
  CoinDetailModel({
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
    super.description,
    super.marketData,
    super.tickers,
    super.communityData,
    super.developerData,
    super.genesisDate,
    super.homepageUrl,
    super.categories,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
    return CoinDetailModel(
      id: json['id'],
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      image: json['image']?['large'],
      currentPrice: json['market_data']?['current_price']?['usd']?.toDouble(),
      marketCap: json['market_data']?['market_cap']?['usd']?.toDouble(),
      marketCapRank: json['market_cap_rank'],
      priceChangePercentage24h: json['market_data']?['price_change_percentage_24h']?.toDouble(),
      high24h: json['market_data']?['high_24h']?['usd']?.toDouble(),
      low24h: json['market_data']?['low_24h']?['usd']?.toDouble(),
      totalVolume: json['market_data']?['total_volume']?['usd']?.toDouble(),
      isFavorite: isFavorite,
      description: json['description']?['en'],
      marketData: json['market_data'],
      tickers: json['tickers'] != null ? List<Map<String, dynamic>>.from(json['tickers']) : null,
      communityData: json['community_data'] != null ? [json['community_data']] : null,
      developerData: json['developer_data'] != null ? [json['developer_data']] : null,
      genesisDate: json['genesis_date'],
      homepageUrl: json['links']?['homepage']?[0],
      categories: json['categories'] != null ? List<String>.from(json['categories']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': {'large': image},
      'market_data': marketData,
      'market_cap_rank': marketCapRank,
      'description': {'en': description},
      'tickers': tickers,
      'community_data': communityData?[0],
      'developer_data': developerData?[0],
      'genesis_date': genesisDate,
      'links': {'homepage': [homepageUrl]},
      'categories': categories,
    };
  }
} 
