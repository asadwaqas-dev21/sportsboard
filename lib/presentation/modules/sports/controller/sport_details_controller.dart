import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/usecases/tournament/get_tournaments_usecase.dart";

class SportDetailsController extends GetxController {
  final GetTournamentsUseCase getTournamentsUseCase;
  final String sportId;

  SportDetailsController({
    required this.getTournamentsUseCase,
    required this.sportId,
  });

  final RxList<Tournament> tournaments = <Tournament>[].obs;
  final RxBool isLoading = true.obs;
  StreamSubscription? _tournamentsSub;

  @override
  void onInit() {
    super.onInit();
    _loadTournaments();
  }

  @override
  void onClose() {
    _tournamentsSub?.cancel();
    super.onClose();
  }

  void _loadTournaments() {
    isLoading.value = true;
    _tournamentsSub = getTournamentsUseCase.execute(sportId: sportId).listen((data) {
      tournaments.value = data;
      isLoading.value = false;
    });
  }
}
