import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/usecases/fixture/get_todays_fixtures_usecase.dart";
import "package:sportsboard/domain/usecases/result/get_results_usecase.dart";
import "package:sportsboard/domain/usecases/sport/get_sports_usecase.dart";

class HomeController extends GetxController {
  final GetSportsUseCase getSportsUseCase;
  final GetTodaysFixturesUseCase getTodaysFixturesUseCase;
  final GetResultsUseCase getResultsUseCase;

  HomeController({
    required this.getSportsUseCase,
    required this.getTodaysFixturesUseCase,
    required this.getResultsUseCase,
  });

  // Bottom Navigation
  final RxInt currentIndex = 0.obs;

  // Data Streams
  final RxList<Sport> sports = <Sport>[].obs;
  final RxList<Fixture> todaysFixtures = <Fixture>[].obs;
  final RxList<Result> recentResults = <Result>[].obs;

  // Loading States
  final RxBool isLoadingSports = true.obs;
  final RxBool isLoadingFixtures = true.obs;
  final RxBool isLoadingResults = true.obs;

  StreamSubscription? _sportsSub;
  StreamSubscription? _fixturesSub;
  StreamSubscription? _resultsSub;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  void onClose() {
    _sportsSub?.cancel();
    _fixturesSub?.cancel();
    _resultsSub?.cancel();
    super.onClose();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void _loadData() {
    _sportsSub = getSportsUseCase.execute().listen((data) {
      sports.value = data;
      isLoadingSports.value = false;
    });

    _fixturesSub = getTodaysFixturesUseCase.execute().listen((data) {
      todaysFixtures.value = data;
      isLoadingFixtures.value = false;
    });

    _resultsSub = getResultsUseCase.execute(limit: 5).listen((data) {
      recentResults.value = data;
      isLoadingResults.value = false;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }
}
