import "package:get/get.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/presentation/modules/splash/binding/splash_binding.dart";
import "package:sportsboard/presentation/modules/splash/view/splash_screen.dart";
import "package:sportsboard/presentation/modules/auth/binding/auth_binding.dart";
import "package:sportsboard/presentation/modules/auth/view/login_screen.dart";
import "package:sportsboard/presentation/modules/home/binding/home_binding.dart";
import "package:sportsboard/presentation/modules/home/view/home_screen.dart";
import "package:sportsboard/presentation/modules/tournament/binding/tournament_binding.dart";
import "package:sportsboard/presentation/modules/tournament/view/tournaments_list_screen.dart";
import "package:sportsboard/presentation/modules/team/binding/team_binding.dart";
import "package:sportsboard/presentation/modules/team/view/teams_list_screen.dart";
import "package:sportsboard/presentation/modules/player/binding/player_binding.dart";
import "package:sportsboard/presentation/modules/player/view/players_list_screen.dart";
import "package:sportsboard/presentation/modules/admin_fixtures/binding/admin_fixtures_binding.dart";
import "package:sportsboard/presentation/modules/admin_fixtures/view/admin_fixtures_screen.dart";
import "package:sportsboard/presentation/modules/result/binding/result_binding.dart";
import "package:sportsboard/presentation/modules/result/view/results_list_screen.dart";
import "package:sportsboard/presentation/modules/standing/binding/standing_binding.dart";
import "package:sportsboard/presentation/modules/standing/view/standings_screen.dart";
import "package:sportsboard/presentation/modules/ranking/binding/ranking_binding.dart";
import "package:sportsboard/presentation/modules/ranking/view/rankings_screen.dart";
import "package:sportsboard/presentation/modules/admin/binding/admin_binding.dart";
import "package:sportsboard/presentation/modules/admin/view/admin_dashboard_screen.dart";
import "package:sportsboard/presentation/modules/sports/binding/admin_sports_binding.dart";
import "package:sportsboard/presentation/modules/sports/view/admin_sports_screen.dart";
import "package:sportsboard/presentation/modules/sports/view/sport_details_screen.dart";

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.tournaments,
      page: () => const TournamentsListScreen(),
      binding: TournamentBinding(),
    ),
    GetPage(
      name: AppRoutes.teams,
      page: () => const TeamsListScreen(),
      binding: TeamBinding(),
    ),
    GetPage(
      name: AppRoutes.players,
      page: () => const PlayersListScreen(),
      binding: PlayerBinding(),
    ),
    GetPage(
      name: AppRoutes.fixtures,
      page: () => const AdminFixturesScreen(),
      binding: AdminFixturesBinding(),
    ),
    GetPage(
      name: AppRoutes.results,
      page: () => const ResultsListScreen(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: AppRoutes.standings,
      page: () => const StandingsScreen(),
      binding: StandingBinding(),
    ),
    GetPage(
      name: AppRoutes.rankings,
      page: () => const RankingsScreen(),
      binding: RankingBinding(),
    ),
    GetPage(
      name: AppRoutes.sports,
      page: () => const AdminSportsScreen(),
      binding: AdminSportsBinding(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.sportDetails,
      page: () => const SportDetailsScreen(),
      binding: BindingsBuilder(() {}),
    ),
  ];
}
