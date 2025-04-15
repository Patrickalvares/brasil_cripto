import 'dart:async';

import 'package:brasil_cripto/utils/cache_item.dart';

import '../constants/api_constants.dart';

class CacheService {
  // Cache para respostas da API
  final Map<String, CacheItem> _apiCache = {};

  // Duração padrão do cache (1 minuto)
  final Duration _defaultCacheExpiration = const Duration(minutes: 1);

  // Contador de requisições por minuto (limite global por IP, não por endpoint)
  int _requestCount = 0;
  DateTime _requestCountResetTime = DateTime.now();
  final int _maxRequestsPerMinute = 50;

  // Singleton instance
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Método para obter dados do cache ou da API
  Future<T?> getCachedData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    required Future<T> Function() fetchFromApi,
    Duration? expiration,
  }) async {
    final cacheKey = _generateCacheKey(endpoint, queryParams);
    final cacheExpiration = expiration ?? _defaultCacheExpiration;

    // Verificar se os dados estão em cache e ainda são válidos
    if (_apiCache.containsKey(cacheKey)) {
      final cachedItem = _apiCache[cacheKey] as CacheItem<T>;
      if (!cachedItem.isExpired(cacheExpiration)) {
        return cachedItem.data;
      } else {
        // Remover dados expirados
        _apiCache.remove(cacheKey);
      }
    }

    // Se estivermos no modo de limitação de taxa forçada, use cache expirado
    if (_forcedRateLimit) {
      if (_apiCache.containsKey(cacheKey)) {
        return (_apiCache[cacheKey] as CacheItem<T>).data;
      }

      throw Exception(
        'Limite de requisições atingido. Algumas funcionalidades podem estar indisponíveis temporariamente.',
      );
    }

    // Verificar se podemos fazer mais requisições
    if (_canMakeRequest()) {
      // Buscar novos dados da API
      try {
        final data = await fetchFromApi();
        // Armazenar no cache
        _apiCache[cacheKey] = CacheItem<T>(
          data: data,
          timestamp: DateTime.now(),
          endpoint: endpoint,
          queryParams: queryParams,
        );
        _incrementRequestCount();
        return data;
      } catch (e) {
        // Em caso de erro, retornar dados do cache mesmo expirados se disponíveis
        if (_apiCache.containsKey(cacheKey)) {
          return (_apiCache[cacheKey] as CacheItem<T>).data;
        }
        rethrow;
      }
    } else {
      // Se atingimos o limite de requisições, usar dados em cache mesmo expirados
      if (_apiCache.containsKey(cacheKey)) {
        return (_apiCache[cacheKey] as CacheItem<T>).data;
      }
      throw Exception(
        'Limite de requisições atingido (50/min). Tente novamente em alguns segundos.',
      );
    }
  }

  // Limpar todo o cache ou itens específicos
  void clearCache({String? endpoint, Map<String, dynamic>? queryParams}) {
    if (endpoint != null) {
      final cacheKey = _generateCacheKey(endpoint, queryParams);
      _apiCache.remove(cacheKey);
    } else {
      _apiCache.clear();
    }
  }

  // Verificar se estamos dentro do limite de requisições
  bool _canMakeRequest() {
    final now = DateTime.now();

    // Resetar contador se já passou 1 minuto
    if (now.difference(_requestCountResetTime) >= const Duration(minutes: 1)) {
      _requestCount = 0;
      _requestCountResetTime = now;
      return true;
    }

    return _requestCount < _maxRequestsPerMinute;
  }

  // Incrementar contador de requisições
  void _incrementRequestCount() {
    _requestCount++;
  }

  // Gerar chave única para o cache baseada no endpoint e parâmetros
  String _generateCacheKey(String endpoint, Map<String, dynamic>? queryParams) {
    if (queryParams == null || queryParams.isEmpty) {
      return endpoint;
    }

    // Ordenar parâmetros para garantir consistência na chave
    final sortedParams = Map.fromEntries(
      queryParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return '$endpoint?${sortedParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  // Variáveis e métodos para gerenciar limitação de taxa forçada
  bool _forcedRateLimit = false;
  DateTime? _forcedRateLimitEndTime;

  // Ativar limitação de taxa forçada por um período específico
  void enforceRateLimit(Duration duration) {
    _forcedRateLimit = true;
    _forcedRateLimitEndTime = DateTime.now().add(duration);

    // Programar o fim da limitação de taxa forçada
    Future.delayed(duration, () {
      if (_forcedRateLimitEndTime != null && DateTime.now().isAfter(_forcedRateLimitEndTime!)) {
        _forcedRateLimit = false;
        _forcedRateLimitEndTime = null;
        _requestCount = 0;
        _requestCountResetTime = DateTime.now();
      }
    });
  }

  // Obter a duração de cache específica para um endpoint
  Duration getEndpointCacheDuration(String endpoint) {
    // Encontra a chave de endpoint que corresponde ao endpoint atual
    for (final entry in ApiConstants.endpointCacheDurations.entries) {
      if (endpoint.startsWith(entry.key)) {
        return entry.value;
      }
    }
    return ApiConstants.defaultCacheExpiration;
  }

  // Obter a contagem atual de requisições
  int get currentRequestCount => _requestCount;

  // Obter o tempo restante até o reset do contador
  Duration get timeUntilReset {
    final resetTime = _requestCountResetTime.add(const Duration(minutes: 1));
    return DateTime.now().isAfter(resetTime) ? Duration.zero : resetTime.difference(DateTime.now());
  }
}
