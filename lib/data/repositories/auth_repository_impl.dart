import "package:firebase_auth/firebase_auth.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";

/// Firebase Auth implementation of AuthRepository with support for persistent mock sessions.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  bool _isMockLoggedIn = false;

  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance {
    _loadMockLoginState();
  }

  Future<void> _loadMockLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMockLoggedIn = prefs.getBool("is_mock_logged_in") ?? false;
    } catch (_) {
      // Gracefully catch potential SharedPreferences init errors
    }
  }

  @override
  Future<String?> login(String email, String password, {bool keepMeLoggedIn = false}) async {
    // Development bypass
    if (email.trim() == "asadwaqas@gmail.com" && password == "553134") {
      _isMockLoggedIn = true;
      if (keepMeLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool("is_mock_logged_in", true);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("is_mock_logged_in");
      }
      return "test_admin_uid";
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      _isMockLoggedIn = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("is_mock_logged_in");
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("is_mock_logged_in");
    
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
    return _auth.authStateChanges().map((user) => _isMockLoggedIn || user != null);
  }
}
