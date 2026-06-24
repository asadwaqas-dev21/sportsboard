import "dart:async";
import "package:get/get.dart";
import "package:sportsboard/domain/entities/result.dart";
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

  final formKey = GlobalKey<FormState>();
  final teamANameController = TextEditingController();
  final teamBNameController = TextEditingController();
  final scoreSummaryController = TextEditingController();

  @override
  void onClose() {
    _resultsSub?.cancel();
    teamANameController.dispose();
    teamBNameController.dispose();
    scoreSummaryController.dispose();
    super.onClose();
  }

  void loadResults(String tournamentId) {
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
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final result = Result(
        id: "",
        fixtureId: "demo_fixture",
        tournamentId: "demo_tournament",
        sportType: "football",
        teamAName: teamANameController.text.trim(),
        teamBName: teamBNameController.text.trim(),
        winnerTeamId: "team_a", // Placeholder
        loserTeamId: "team_b", // Placeholder
        scoreSummary: scoreSummaryController.text.trim(),
        resultText: "${teamANameController.text.trim()} won",
        addedBy: "admin",
        createdAt: DateTime.now(),
      );

      await createResultUseCase.execute(result);

      Get.back();
      SnackbarUtils.showSuccess("Result added successfully");

      teamANameController.clear();
      teamBNameController.clear();
      scoreSummaryController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
