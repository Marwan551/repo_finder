class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server Error occurred'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Error occurred'});
}
