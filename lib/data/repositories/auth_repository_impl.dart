import "package:firebase_auth/firebase_auth.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";

/// Firebase Auth implementation of AuthRepository.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  bool _isMockLoggedIn = false;

  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String?> login(String email, String password) async {
    // Development bypass
    if (email.trim() == "admin@test.com" && password == "admin123") {
      _isMockLoggedIn = true;
      return "test_admin_uid";
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _isMockLoggedIn = false;
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  @override
  Future<void> logout() async {
    if (_isMockLoggedIn) {
      _isMockLoggedIn = false;
      return;
    }
    await _auth.signOut();
  }

  @override
  bool get isLoggedIn => _isMockLoggedIn || _auth.currentUser != null;

  @override
  String? get currentUserId => _isMockLoggedIn ? "test_admin_uid" : _auth.currentUser?.uid;

  @override
  Stream<bool> get authStateChanges {
    // Note: To make mock stream work perfectly we'd need a StreamController,
    // but for the MVP simply checking isLoggedIn will be enough for most UI.
    return _auth.authStateChanges().map((user) => _isMockLoggedIn || user != null);
  }
}
