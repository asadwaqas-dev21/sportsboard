import "package:get/get.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:sportsboard/core/theme/theme_controller.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";
import "package:sportsboard/domain/repositories/tournament_repository.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";
import "package:sportsboard/domain/repositories/player_repository.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";
import "package:sportsboard/domain/repositories/player_stats_repository.dart";
import "package:sportsboard/data/repositories/auth_repository_impl.dart";
import "package:sportsboard/data/repositories/sport_repository_impl.dart";
import "package:sportsboard/data/repositories/tournament_repository_impl.dart";
import "package:sportsboard/data/repositories/team_repository_impl.dart";
import "package:sportsboard/data/repositories/player_repository_impl.dart";
import "package:sportsboard/data/repositories/fixture_repository_impl.dart";
import "package:sportsboard/data/repositories/result_repository_impl.dart";
import "package:sportsboard/data/repositories/standing_repository_impl.dart";
import "package:sportsboard/data/repositories/player_stats_repository_impl.dart";

/// Initial bindings to inject core dependencies when app starts.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Controllers (Keep alive throughout app lifecycle)
    Get.put(ThemeController(), permanent: true);

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(auth: FirebaseAuth.instance),
      fenix: true,
    );
    Get.lazyPut<SportRepository>(
      () => SportRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<TournamentRepository>(
      () => TournamentRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<TeamRepository>(
      () => TeamRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<PlayerRepository>(
      () => PlayerRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<FixtureRepository>(
      () => FixtureRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<ResultRepository>(
      () => ResultRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<StandingRepository>(
      () => StandingRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
    Get.lazyPut<PlayerStatsRepository>(
      () => PlayerStatsRepositoryImpl(firestore: FirebaseFirestore.instance),
      fenix: true,
    );
  }
}
