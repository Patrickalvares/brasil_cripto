class Coin {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? priceChangePercentage24h;
  final double? high24h;
  final double? low24h;
  final double? totalVolume;
  final List<double>? sparklineData;
  final bool isFavorite;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.priceChangePercentage24h,
    this.high24h,
    this.low24h,
    this.totalVolume,
    this.sparklineData,
    this.isFavorite = false,
  });

  Coin copyWith({
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
  }) {
    return Coin(
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
    );
  }
} 
