import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/tournament_repository.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";
import "package:sportsboard/domain/usecases/fixture/create_fixture_usecase.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";

class AdminFixturesController extends GetxController {
  final FixtureRepository fixtureRepository;
  final CreateFixtureUseCase createFixtureUseCase;

  AdminFixturesController({
    required this.fixtureRepository,
    required this.createFixtureUseCase,
  });

  final RxList<Fixture> fixtures = <Fixture>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  
  StreamSubscription? _fixturesSub;
  StreamSubscription? _tournamentsSub;
  StreamSubscription? _teamsSub;

  final RxList<Tournament> tournaments = <Tournament>[].obs;
  final Rxn<Tournament> selectedTournament = Rxn<Tournament>();

  final RxList<Team> teams = <Team>[].obs;
  final Rxn<Team> selectedTeamA = Rxn<Team>();
  final Rxn<Team> selectedTeamB = Rxn<Team>();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadFixtures();
    _loadTournaments();
    _loadTeams();
  }

  @override
  void onClose() {
    _fixturesSub?.cancel();
    _tournamentsSub?.cancel();
    _teamsSub?.cancel();
    super.onClose();
  }

  void _loadFixtures() {
    isLoading.value = true;
    _fixturesSub?.cancel();
    _fixturesSub = fixtureRepository.getFixtures().listen((data) {
      fixtures.value = data;
      isLoading.value = false;
    });
  }

  void _loadTournaments() {
    _tournamentsSub?.cancel();
    _tournamentsSub = Get.find<TournamentRepository>().getTournaments().listen((data) {
      tournaments.value = data;
      if (data.isNotEmpty && selectedTournament.value == null) {
        selectedTournament.value = data.first;
      }
    });
  }

  void _loadTeams() {
    _teamsSub?.cancel();
    _teamsSub = Get.find<TeamRepository>().getTeams().listen((data) {
      teams.value = data;
      if (data.isNotEmpty) {
        if (selectedTeamA.value == null) selectedTeamA.value = data.first;
        if (data.length > 1 && selectedTeamB.value == null) selectedTeamB.value = data[1];
      }
    });
  }

  Future<void> addFixture() async {
    final tournament = selectedTournament.value;
    final teamA = selectedTeamA.value;
    final teamB = selectedTeamB.value;

    if (tournament == null || teamA == null || teamB == null) {
      SnackbarUtils.showError("Please select a tournament and two teams");
      return;
    }

    if (teamA.id == teamB.id) {
      SnackbarUtils.showError("Team A and Team B cannot be the same");
      return;
    }

    isSaving.value = true;
    try {
      final fixture = Fixture(
        id: "",
        tournamentId: tournament.id,
        teamAId: teamA.id,
        teamBId: teamB.id,
        teamAName: teamA.name,
        teamBName: teamB.name,
        date: DateTime.now(),
        status: "upcoming",
      );

      await createFixtureUseCase.execute(fixture);
      
      Get.back(); // Close dialog
      SnackbarUtils.showSuccess("Fixture added successfully");
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
