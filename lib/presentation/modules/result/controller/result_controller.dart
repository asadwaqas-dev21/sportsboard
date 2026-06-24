import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/usecases/result/get_results_usecase.dart";
import "package:sportsboard/domain/usecases/result/create_result_usecase.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:flutter/material.dart";

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
  final scoreSummaryController = TextEditingController();

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
    _resultsSub = getResultsUseCase.execute(tournamentId: tournamentId).listen((
      data,
    ) {
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

      final result = Result(
        id: "",
        fixtureId: fixture.id,
        tournamentId: fixture.tournamentId,
        sportType: "football", // fallback, or can be derived if sport details existed
        teamAName: fixture.teamAName,
        teamBName: fixture.teamBName,
        winnerTeamId: winner,
        loserTeamId: loser,
        scoreSummary: scoreSummaryController.text.trim(),
        resultText: isTeamAWinner.value 
            ? "${fixture.teamAName} won" 
            : "${fixture.teamBName} won",
        addedBy: "admin",
        createdAt: DateTime.now(),
      );

      await createResultUseCase.execute(result);

      Get.back();
      SnackbarUtils.showSuccess("Result added successfully");
      scoreSummaryController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
