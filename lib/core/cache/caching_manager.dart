class CachingManager<T> {
  const CachingManager(this.data, {this.fromCache = false, this.createdAt});

  final T data;
  final bool fromCache;
  final DateTime? createdAt;
}
