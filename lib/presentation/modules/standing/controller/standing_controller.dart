import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";

class StandingController extends GetxController {
  final StandingRepository standingRepository;

  StandingController({required this.standingRepository});

  final RxList<Standing> standings = <Standing>[].obs;
  final RxBool isLoading = true.obs;
  StreamSubscription? _standingsSub;

  @override
  void onClose() {
    _standingsSub?.cancel();
    super.onClose();
  }

  void loadStandings(String tournamentId) {
    isLoading.value = true;
    _standingsSub?.cancel();
    _standingsSub = standingRepository.getStandings(tournamentId).listen((data) {
      standings.value = data;
      isLoading.value = false;
    });
  }
}
