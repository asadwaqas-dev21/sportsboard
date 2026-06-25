import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";
import "package:sportsboard/domain/usecases/result/create_result_usecase.dart";
import "package:sportsboard/domain/usecases/result/get_results_usecase.dart";
import "package:sportsboard/domain/usecases/standing/calculate_standings_usecase.dart";

class ResultController extends GetxController {
  final GetResultsUseCase getResultsUseCase;
  final CreateResultUseCase createResultUseCase;
  final CalculateStandingsUseCase calculateStandingsUseCase;
  final FixtureRepository fixtureRepository;
  final TeamRepository teamRepository;

  ResultController({
    required this.getResultsUseCase,
    required this.createResultUseCase,
    required this.calculateStandingsUseCase,
    required this.fixtureRepository,
    required this.teamRepository,
  });

  final RxList<Result> results = <Result>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  StreamSubscription? _resultsSub;
  StreamSubscription? _fixturesSub;

  final RxList<Fixture> fixtures = <Fixture>[].obs;
  final Rxn<Fixture> selectedFixture = Rxn<Fixture>();
  final RxBool isTeamAWinner = true.obs;

  final formKey = GlobalKey<FormState>();

  // Generic / Custom controller
  final scoreSummaryController = TextEditingController();

  // Cricket controllers
  final teamARunsController = TextEditingController();
  final teamAWicketsController = TextEditingController();
  final teamAOversController = TextEditingController();
  final teamBRunsController = TextEditingController();
  final teamBWicketsController = TextEditingController();
  final teamBOversController = TextEditingController();

  // Football controllers
  final teamAGoalsController = TextEditingController();
  final teamBGoalsController = TextEditingController();

  // Badminton controllers
  final teamASetsController = TextEditingController();
  final teamBSetsController = TextEditingController();
  final setScoresController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadResults();
    _loadFixtures();
    _setupAutoWinnerListeners();
  }

  @override
  void onClose() {
    _resultsSub?.cancel();
    _fixturesSub?.cancel();

    scoreSummaryController.dispose();

    teamARunsController.dispose();
    teamAWicketsController.dispose();
    teamAOversController.dispose();
    teamBRunsController.dispose();
    teamBWicketsController.dispose();
    teamBOversController.dispose();

    teamAGoalsController.dispose();
    teamBGoalsController.dispose();

    teamASetsController.dispose();
    teamBSetsController.dispose();
    setScoresController.dispose();

    super.onClose();
  }

  /// Set up listeners on score fields to auto-determine the winner.
  void _setupAutoWinnerListeners() {
    // Cricket: auto-select winner based on runs
    teamARunsController.addListener(_autoSelectCricketWinner);
    teamBRunsController.addListener(_autoSelectCricketWinner);

    // Football: auto-select winner based on goals
    teamAGoalsController.addListener(_autoSelectFootballWinner);
    teamBGoalsController.addListener(_autoSelectFootballWinner);

    // Badminton: auto-select winner based on sets
    teamASetsController.addListener(_autoSelectBadmintonWinner);
    teamBSetsController.addListener(_autoSelectBadmintonWinner);
  }

  void _autoSelectCricketWinner() {
    final aRuns = int.tryParse(teamARunsController.text) ?? 0;
    final bRuns = int.tryParse(teamBRunsController.text) ?? 0;
    if (aRuns > 0 || bRuns > 0) {
      isTeamAWinner.value = aRuns >= bRuns;
    }
  }

  void _autoSelectFootballWinner() {
    final aGoals = int.tryParse(teamAGoalsController.text) ?? 0;
    final bGoals = int.tryParse(teamBGoalsController.text) ?? 0;
    if (aGoals > 0 || bGoals > 0) {
      isTeamAWinner.value = aGoals >= bGoals;
    }
  }

  void _autoSelectBadmintonWinner() {
    final aSets = int.tryParse(teamASetsController.text) ?? 0;
    final bSets = int.tryParse(teamBSetsController.text) ?? 0;
    if (aSets > 0 || bSets > 0) {
      isTeamAWinner.value = aSets >= bSets;
    }
  }

  void _loadFixtures() {
    _fixturesSub?.cancel();
    _fixturesSub = fixtureRepository.getFixtures().listen((data) {
      fixtures.value = data;
      if (data.isNotEmpty && selectedFixture.value == null) {
        selectedFixture.value = data.first;
      }
    });
  }

  void loadResults({String? tournamentId}) {
    isLoading.value = true;
    _resultsSub?.cancel();
    _resultsSub =
        getResultsUseCase.execute(tournamentId: tournamentId).listen((data) {
      results.value = data;
      isLoading.value = false;
    });
  }

  /// Calculates run rate: runs / overs. Handles fractional overs (e.g. 19.3).
  double _calculateRunRate(int runs, double overs) {
    if (overs <= 0) return 0.0;
    // Convert fractional overs to decimal overs (e.g. 19.3 -> 19.5)
    final completedOvers = overs.truncate();
    final extraBalls = ((overs - completedOvers) * 10).round();
    final decimalOvers = completedOvers + (extraBalls / 6.0);
    if (decimalOvers <= 0) return 0.0;
    return runs / decimalOvers;
  }

  Future<void> addResult() async {
    final fixture = selectedFixture.value;
    if (fixture == null) {
      SnackbarUtils.showError("Please select a fixture");
      return;
    }
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final sType = fixture.sportType.toLowerCase();
      String scoreSummary = "";
      String resultText = "";
      Map<String, dynamic>? cricketData;
      Map<String, dynamic>? footballData;
      Map<String, dynamic>? indoorData;

      if (sType.contains("cricket")) {
        final aRuns = int.tryParse(teamARunsController.text) ?? 0;
        final aWickets = int.tryParse(teamAWicketsController.text) ?? 0;
        final aOvers = double.tryParse(teamAOversController.text) ?? 0.0;

        final bRuns = int.tryParse(teamBRunsController.text) ?? 0;
        final bWickets = int.tryParse(teamBWicketsController.text) ?? 0;
        final bOvers = double.tryParse(teamBOversController.text) ?? 0.0;

        // Auto-determine the winner based on runs
        isTeamAWinner.value = aRuns >= bRuns;

        // Calculate individual run rates
        final aRR = _calculateRunRate(aRuns, aOvers);
        final bRR = _calculateRunRate(bRuns, bOvers);

        scoreSummary =
            "$aRuns/$aWickets ($aOvers ov, RR: ${aRR.toStringAsFixed(2)})"
            " - "
            "$bRuns/$bWickets ($bOvers ov, RR: ${bRR.toStringAsFixed(2)})";

        cricketData = {
          "teamARuns": aRuns,
          "teamAWickets": aWickets,
          "teamAOvers": aOvers,
          "teamBRuns": bRuns,
          "teamBWickets": bWickets,
          "teamBOvers": bOvers,
        };

        final winnerName =
            isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        if (aRuns == bRuns) {
          resultText = "Match Tied";
        } else if (isTeamAWinner.value) {
          // Team A (batted first / defended) won by runs
          final diffRuns = aRuns - bRuns;
          resultText = "$winnerName won by $diffRuns runs";
        } else {
          // Team B (chasing) won by wickets remaining
          final diffWickets = 10 - bWickets;
          resultText = "$winnerName won by $diffWickets wickets";
        }
      } else if (sType.contains("football")) {
        final aGoals = int.tryParse(teamAGoalsController.text) ?? 0;
        final bGoals = int.tryParse(teamBGoalsController.text) ?? 0;

        // Auto-determine the winner based on goals
        isTeamAWinner.value = aGoals >= bGoals;

        scoreSummary = "$aGoals - $bGoals";

        footballData = {
          "teamAGoals": aGoals,
          "teamBGoals": bGoals,
        };

        if (aGoals == bGoals) {
          resultText = "Match Draw";
        } else {
          final winnerName =
              isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
          resultText = "$winnerName won $scoreSummary";
        }
      } else if (sType.contains("badminton")) {
        final aSets = int.tryParse(teamASetsController.text) ?? 0;
        final bSets = int.tryParse(teamBSetsController.text) ?? 0;
        final setScores = setScoresController.text.trim();

        // Auto-determine the winner based on sets
        isTeamAWinner.value = aSets >= bSets;

        scoreSummary = "$aSets - $bSets";
        if (setScores.isNotEmpty) {
          scoreSummary += " ($setScores)";
        }

        indoorData = {
          "teamASets": aSets,
          "teamBSets": bSets,
          "setScores": setScores,
        };

        final winnerName =
            isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        resultText = "$winnerName won $aSets-$bSets";
      } else {
        // Generic / Fallback
        scoreSummary = scoreSummaryController.text.trim();
        final winnerName =
            isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        resultText = "$winnerName won";
      }

      final winner = isTeamAWinner.value ? fixture.teamAId : fixture.teamBId;
      final loser = isTeamAWinner.value ? fixture.teamBId : fixture.teamAId;

      final result = Result(
        id: "",
        fixtureId: fixture.id,
        tournamentId: fixture.tournamentId,
        sportType: fixture.sportType,
        teamAName: fixture.teamAName,
        teamBName: fixture.teamBName,
        winnerTeamId: winner,
        loserTeamId: loser,
        scoreSummary: scoreSummary,
        resultText: resultText,
        addedBy: "admin",
        createdAt: DateTime.now(),
        cricketData: cricketData,
        footballData: footballData,
        indoorData: indoorData,
      );

      // 1. Save the result
      await createResultUseCase.execute(result);

      // 2. Mark the fixture as completed
      await fixtureRepository.updateFixture(
        fixture.copyWith(status: "completed"),
      );

      // 3. Get teams for this tournament and recalculate standings
      try {
        final teamsStream =
            teamRepository.getTeams(tournamentId: fixture.tournamentId);
        final teams = await teamsStream.first;
        if (teams.isNotEmpty) {
          await calculateStandingsUseCase.execute(
            fixture.tournamentId,
            fixture.sportType,
            teams,
          );
        }
      } catch (_) {
        // Standings recalculation is best-effort; don't fail the result save
      }

      Get.back();
      SnackbarUtils.showSuccess("Result added successfully");

      // Clear controllers
      _clearControllers();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  void _clearControllers() {
    scoreSummaryController.clear();
    teamARunsController.clear();
    teamAWicketsController.clear();
    teamAOversController.clear();
    teamBRunsController.clear();
    teamBWicketsController.clear();
    teamBOversController.clear();
    teamAGoalsController.clear();
    teamBGoalsController.clear();
    teamASetsController.clear();
    teamBSetsController.clear();
    setScoresController.clear();
  }
}
