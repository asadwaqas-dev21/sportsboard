/// Application-level failure classes for error handling.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server error occurred"]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = "Authentication failed"]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Cache error occurred"]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = "Resource not found"]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = "Validation error"]);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = "Permission denied"]);
}
