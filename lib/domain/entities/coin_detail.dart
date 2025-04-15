import 'coin.dart';

class CoinDetail extends Coin {
  final String? description;
  final Map<String, dynamic>? marketData;
  final List<Map<String, dynamic>>? tickers;
  final List<Map<String, dynamic>>? communityData;
  final List<Map<String, dynamic>>? developerData;
  final String? genesisDate;
  final String? homepageUrl;
  final List<String>? categories;

  CoinDetail({
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
    this.description,
    this.marketData,
    this.tickers,
    this.communityData,
    this.developerData,
    this.genesisDate,
    this.homepageUrl,
    this.categories,
  });

  @override
  CoinDetail copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? priceChangePercentage24h,
    double? high24h,
    double? low24h,
    double? totalVolume,
    List<double>? sparklineData,
    bool? isFavorite,
    String? description,
    Map<String, dynamic>? marketData,
    List<Map<String, dynamic>>? tickers,
    List<Map<String, dynamic>>? communityData,
    List<Map<String, dynamic>>? developerData,
    String? genesisDate,
    String? homepageUrl,
    List<String>? categories,
  }) {
    return CoinDetail(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      totalVolume: totalVolume ?? this.totalVolume,
      sparklineData: sparklineData ?? this.sparklineData,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      marketData: marketData ?? this.marketData,
      tickers: tickers ?? this.tickers,
      communityData: communityData ?? this.communityData,
      developerData: developerData ?? this.developerData,
      genesisDate: genesisDate ?? this.genesisDate,
      homepageUrl: homepageUrl ?? this.homepageUrl,
      categories: categories ?? this.categories,
    );
  }
} 
