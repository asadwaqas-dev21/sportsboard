/// Abstract auth repository contract.
abstract class AuthRepository {
  Future<String?> login(String email, String password);
  Future<void> logout();
  bool get isLoggedIn;
  String? get currentUserId;
  Stream<bool> get authStateChanges;
}
