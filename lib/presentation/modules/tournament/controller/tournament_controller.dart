import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";
import "package:sportsboard/domain/usecases/tournament/create_tournament_usecase.dart";
import "package:sportsboard/domain/usecases/tournament/get_tournaments_usecase.dart";

class TournamentController extends GetxController {
  final GetTournamentsUseCase getTournamentsUseCase;
  final CreateTournamentUseCase createTournamentUseCase;

  TournamentController({
    required this.getTournamentsUseCase,
    required this.createTournamentUseCase,
  });

  final RxList<Tournament> tournaments = <Tournament>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  StreamSubscription? _tournamentsSub;
  StreamSubscription? _sportsSub;

  final RxList<Sport> sports = <Sport>[].obs;
  final Rxn<Sport> selectedSport = Rxn<Sport>();

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadTournaments();
    _loadSports();
  }

  @override
  void onClose() {
    _tournamentsSub?.cancel();
    _sportsSub?.cancel();
    nameController.dispose();
    super.onClose();
  }

  void _loadSports() {
    _sportsSub?.cancel();
    _sportsSub = Get.find<SportRepository>().getSports().listen((data) {
      sports.value = data;
      if (data.isNotEmpty && selectedSport.value == null) {
        selectedSport.value = data.first;
      }
    });
  }

  void _loadTournaments({String? sportId}) {
    isLoading.value = true;
    _tournamentsSub?.cancel();
    _tournamentsSub = getTournamentsUseCase.execute(sportId: sportId).listen((data) {
      tournaments.value = data;
      isLoading.value = false;
    });
  }

  void filterBySport(String sportId) {
    _loadTournaments(sportId: sportId);
  }

  Future<void> saveTournament(String sportId, String sportName) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final tournament = Tournament(
        id: "", // Let repo generate ID
        sportId: sportId,
        sportName: sportName,
        name: nameController.text.trim(),
        startDate: DateTime.now(), // Simplified
        status: "upcoming",
      );

      await createTournamentUseCase.execute(tournament);
      Get.back();
      SnackbarUtils.showSuccess("Tournament created successfully");
      nameController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
