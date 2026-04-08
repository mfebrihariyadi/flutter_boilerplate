abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server Error Occurred']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'No Internet Connection']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache Error Occurred']);
}

class UnknownFailure extends Failure {
  UnknownFailure([super.message = 'Unknown Error Occurred']);
}
