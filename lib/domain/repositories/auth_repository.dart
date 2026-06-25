/// Abstract auth repository contract.
abstract class AuthRepository {
  Future<String?> login(String email, String password, {bool keepMeLoggedIn = false});
  Future<void> logout();
  bool get isLoggedIn;
  String? get currentUserId;
  Stream<bool> get authStateChanges;
}
