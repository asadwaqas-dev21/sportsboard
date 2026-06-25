import "package:sportsboard/domain/repositories/auth_repository.dart";

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<String?> execute(String email, String password, {bool keepMeLoggedIn = false}) {
    return repository.login(email, password, keepMeLoggedIn: keepMeLoggedIn);
  }
}
