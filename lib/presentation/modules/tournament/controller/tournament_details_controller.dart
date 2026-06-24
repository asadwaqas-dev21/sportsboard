import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/entities/tournament.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";
import "package:sportsboard/domain/usecases/standing/calculate_standings_usecase.dart";

class TournamentDetailsController extends GetxController {
  final Tournament tournament;
  final TeamRepository teamRepository;
  final StandingRepository standingRepository;
  final FixtureRepository fixtureRepository;
  final CalculateStandingsUseCase calculateStandingsUseCase;
  final AuthRepository authRepository;

  TournamentDetailsController({
    required this.tournament,
    required this.teamRepository,
    required this.standingRepository,
    required this.fixtureRepository,
    required this.calculateStandingsUseCase,
    required this.authRepository,
  });

  // Dynamic lists
  final RxList<Team> teams = <Team>[].obs;
  final RxList<Standing> standings = <Standing>[].obs;
  final RxList<Fixture> fixtures = <Fixture>[].obs;
  final RxList<Sport> _sports = <Sport>[].obs;

  // Loading states
  final RxBool isLoadingTeams = true.obs;
  final RxBool isLoadingStandings = true.obs;
  final RxBool isLoadingFixtures = true.obs;
  final RxBool isSaving = false.obs;

  // Stream Subscriptions
  StreamSubscription? _teamsSub;
  StreamSubscription? _standingsSub;
  StreamSubscription? _fixturesSub;
  StreamSubscription? _sportsSub;

  // Form states - Add Team
  final addTeamFormKey = GlobalKey<FormState>();
  final teamNameController = TextEditingController();
  final teamCaptainController = TextEditingController();

  // Form states - Add Fixture
  final addFixtureFormKey = GlobalKey<FormState>();
  final fixtureVenueController = TextEditingController();
  final fixtureTimeController = TextEditingController();
  final Rxn<Team> selectedTeamA = Rxn<Team>();
  final Rxn<Team> selectedTeamB = Rxn<Team>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  // Form states - Add/Edit Standing
  final editStandingFormKey = GlobalKey<FormState>();
  final Rxn<Team> standingSelectedTeam = Rxn<Team>();
  final standingPlayedController = TextEditingController();
  final standingWonController = TextEditingController();
  final standingLostController = TextEditingController();
  final standingDrawController = TextEditingController();
  final standingPointsController = TextEditingController();
  final standingNrrController = TextEditingController();
  final standingGoalsForController = TextEditingController();
  final standingGoalsAgainstController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadTeams();
    _loadStandings();
    _loadFixtures();
    _loadSports();
  }

  @override
  void onClose() {
    _teamsSub?.cancel();
    _standingsSub?.cancel();
    _fixturesSub?.cancel();
    _sportsSub?.cancel();

    teamNameController.dispose();
    teamCaptainController.dispose();
    fixtureVenueController.dispose();
    fixtureTimeController.dispose();
    
    standingPlayedController.dispose();
    standingWonController.dispose();
    standingLostController.dispose();
    standingDrawController.dispose();
    standingPointsController.dispose();
    standingNrrController.dispose();
    standingGoalsForController.dispose();
    standingGoalsAgainstController.dispose();

    super.onClose();
  }

  bool get isAdmin => authRepository.isLoggedIn;

  String get sportTypeStr {
    final sport = _sports.firstWhereOrNull((s) => s.id == tournament.sportId);
    return sport?.type ?? "football";
  }

  void _loadSports() {
    _sportsSub?.cancel();
    _sportsSub = Get.find<SportRepository>().getSports().listen((data) {
      _sports.value = data;
    });
  }

  void _loadTeams() {
    isLoadingTeams.value = true;
    _teamsSub?.cancel();
    _teamsSub = teamRepository.getTeams(tournamentId: tournament.id).listen((data) {
      teams.value = data;
      isLoadingTeams.value = false;
      
      // Auto-populate fixture dropdown selections when teams load
      if (data.isNotEmpty) {
        if (selectedTeamA.value == null) selectedTeamA.value = data.first;
        if (data.length > 1 && selectedTeamB.value == null) {
          selectedTeamB.value = data[1];
        }
      }
    });
  }

  void _loadStandings() {
    isLoadingStandings.value = true;
    _standingsSub?.cancel();
    _standingsSub = standingRepository.getStandings(tournament.id).listen((data) {
      standings.value = data;
      isLoadingStandings.value = false;
    });
  }

  void _loadFixtures() {
    isLoadingFixtures.value = true;
    _fixturesSub?.cancel();
    _fixturesSub = fixtureRepository.getFixtures(tournamentId: tournament.id).listen((data) {
      fixtures.value = data;
      isLoadingFixtures.value = false;
    });
  }

  // --- ACTIONS ---

  Future<void> addTeam() async {
    if (!addTeamFormKey.currentState!.validate()) return;
    isSaving.value = true;
    try {
      final team = Team(
        id: "",
        tournamentId: tournament.id,
        name: teamNameController.text.trim(),
        captainName: teamCaptainController.text.trim(),
      );
      await teamRepository.addTeam(team);
      Get.back();
      SnackbarUtils.showSuccess("Team added successfully");
      teamNameController.clear();
      teamCaptainController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addFixture() async {
    final tA = selectedTeamA.value;
    final tB = selectedTeamB.value;
    final date = selectedDate.value;
    final time = fixtureTimeController.text.trim();
    final venue = fixtureVenueController.text.trim();

    if (tA == null || tB == null || date == null) {
      SnackbarUtils.showError("Please fill in teams and date");
      return;
    }

    if (tA.id == tB.id) {
      SnackbarUtils.showError("Team A and Team B cannot be the same");
      return;
    }

    isSaving.value = true;
    try {
      final fixture = Fixture(
        id: "",
        tournamentId: tournament.id,
        tournamentName: tournament.name,
        sportType: tournament.sportName,
        teamAId: tA.id,
        teamBId: tB.id,
        teamAName: tA.name,
        teamBName: tB.name,
        date: date,
        time: time,
        venue: venue,
        status: "upcoming",
      );
      await fixtureRepository.addFixture(fixture);
      Get.back();
      SnackbarUtils.showSuccess("Fixture added successfully");
      fixtureVenueController.clear();
      fixtureTimeController.clear();
      selectedDate.value = null;
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addOrUpdateStanding() async {
    final team = standingSelectedTeam.value;
    if (team == null) {
      SnackbarUtils.showError("Please select a team");
      return;
    }

    isSaving.value = true;
    try {
      // Check if there is an existing standing for this team in the list
      final existing = standings.firstWhereOrNull((s) => s.teamId == team.id);

      final played = int.tryParse(standingPlayedController.text) ?? 0;
      final won = int.tryParse(standingWonController.text) ?? 0;
      final lost = int.tryParse(standingLostController.text) ?? 0;
      final draw = int.tryParse(standingDrawController.text) ?? 0;
      final points = int.tryParse(standingPointsController.text) ?? 0;
      
      final nrr = double.tryParse(standingNrrController.text) ?? 0.0;
      final goalsFor = int.tryParse(standingGoalsForController.text) ?? 0;
      final goalsAgainst = int.tryParse(standingGoalsAgainstController.text) ?? 0;

      final standing = Standing(
        id: existing?.id ?? "",
        tournamentId: tournament.id,
        teamId: team.id,
        teamName: team.name,
        played: played,
        won: won,
        lost: lost,
        draw: draw,
        points: points,
        netRunRate: nrr,
        goalsFor: goalsFor,
        goalsAgainst: goalsAgainst,
        goalDifference: goalsFor - goalsAgainst,
      );

      await standingRepository.saveStandings([standing]);
      Get.back();
      SnackbarUtils.showSuccess("Standing saved successfully");
      
      // Clear forms
      standingPlayedController.clear();
      standingWonController.clear();
      standingLostController.clear();
      standingDrawController.clear();
      standingPointsController.clear();
      standingNrrController.clear();
      standingGoalsForController.clear();
      standingGoalsAgainstController.clear();
      standingSelectedTeam.value = null;
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> recalculateStandings() async {
    if (teams.isEmpty) {
      SnackbarUtils.showError("Cannot recalculate standings: no participant teams found");
      return;
    }

    isSaving.value = true;
    try {
      await calculateStandingsUseCase.execute(tournament.id, sportTypeStr, teams);
      SnackbarUtils.showSuccess("Standings recalculated successfully");
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
