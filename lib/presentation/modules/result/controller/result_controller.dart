import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/usecases/result/create_result_usecase.dart";
import "package:sportsboard/domain/usecases/result/get_results_usecase.dart";

class ResultController extends GetxController {
  final GetResultsUseCase getResultsUseCase;
  final CreateResultUseCase createResultUseCase;

  ResultController({
    required this.getResultsUseCase,
    required this.createResultUseCase,
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

  void _loadFixtures() {
    _fixturesSub?.cancel();
    _fixturesSub = Get.find<FixtureRepository>().getFixtures().listen((data) {
      fixtures.value = data;
      if (data.isNotEmpty && selectedFixture.value == null) {
        selectedFixture.value = data.first;
      }
    });
  }

  void loadResults({String? tournamentId}) {
    isLoading.value = true;
    _resultsSub?.cancel();
    _resultsSub = getResultsUseCase.execute(tournamentId: tournamentId).listen((data) {
      results.value = data;
      isLoading.value = false;
    });
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
      final winner = isTeamAWinner.value ? fixture.teamAId : fixture.teamBId;
      final loser = isTeamAWinner.value ? fixture.teamBId : fixture.teamAId;

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

        scoreSummary = "$aRuns/$aWickets ($aOvers ov) - $bRuns/$bWickets ($bOvers ov)";
        
        cricketData = {
          "teamARuns": aRuns,
          "teamAWickets": aWickets,
          "teamAOvers": aOvers,
          "teamBRuns": bRuns,
          "teamBWickets": bWickets,
          "teamBOvers": bOvers,
        };

        final winnerName = isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        if (isTeamAWinner.value) {
          final diffRuns = aRuns - bRuns;
          if (diffRuns > 0) {
            resultText = "$winnerName won by $diffRuns runs";
          } else {
            final diffWickets = 10 - aWickets;
            resultText = "$winnerName won by $diffWickets wickets";
          }
        } else {
          final diffRuns = bRuns - aRuns;
          if (diffRuns > 0) {
            resultText = "$winnerName won by $diffRuns runs";
          } else {
            final diffWickets = 10 - bWickets;
            resultText = "$winnerName won by $diffWickets wickets";
          }
        }
      } else if (sType.contains("football")) {
        final aGoals = int.tryParse(teamAGoalsController.text) ?? 0;
        final bGoals = int.tryParse(teamBGoalsController.text) ?? 0;

        scoreSummary = "$aGoals - $bGoals";
        
        footballData = {
          "teamAGoals": aGoals,
          "teamBGoals": bGoals,
        };

        if (aGoals == bGoals) {
          resultText = "Match Draw";
        } else {
          final winnerName = isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
          resultText = "$winnerName won $scoreSummary";
        }
      } else if (sType.contains("badminton")) {
        final aSets = int.tryParse(teamASetsController.text) ?? 0;
        final bSets = int.tryParse(teamBSetsController.text) ?? 0;
        final setScores = setScoresController.text.trim();

        scoreSummary = "$aSets - $bSets";
        if (setScores.isNotEmpty) {
          scoreSummary += " ($setScores)";
        }

        indoorData = {
          "teamASets": aSets,
          "teamBSets": bSets,
          "setScores": setScores,
        };

        final winnerName = isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        resultText = "$winnerName won $aSets-$bSets";
      } else {
        // Generic / Fallback
        scoreSummary = scoreSummaryController.text.trim();
        final winnerName = isTeamAWinner.value ? fixture.teamAName : fixture.teamBName;
        resultText = "$winnerName won";
      }

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

      await createResultUseCase.execute(result);

      Get.back();
      SnackbarUtils.showSuccess("Result added successfully");

      // Clear controllers
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
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
