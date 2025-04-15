class CacheItem<T> {
  final T data;
  final DateTime timestamp;
  final String endpoint;
  final Map<String, dynamic>? queryParams;

  CacheItem({
    required this.data,
    required this.timestamp,
    required this.endpoint,
    this.queryParams,
  });

  bool isExpired(Duration expirationDuration) {
    return DateTime.now().difference(timestamp) > expirationDuration;
  }
}
