class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  
  // Endpoints
  static const String coins = '/coins';
  static const String markets = '/coins/markets';
  static const String search = '/search';
  static const String trending = '/search/trending';
  
  // Parâmetros
  static const String vsCurrency = 'vs_currency';
  static const String ids = 'ids';
  static const String order = 'order';
  static const String perPage = 'per_page';
  static const String page = 'page';
  static const String sparkline = 'sparkline';
  static const String priceChangePercentage = 'price_change_percentage';
  static const String query = 'query';
  
  // Valores padrão
  static const String defaultCurrency = 'usd';
  static const int defaultPerPage = 20;
  static const int defaultPage = 1;
  static const String defaultOrder = 'market_cap_desc';
} 
