import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/fixture.dart";
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

  final formKey = GlobalKey<FormState>();
  final teamANameController = TextEditingController();
  final teamBNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadFixtures();
  }

  @override
  void onClose() {
    _fixturesSub?.cancel();
    teamANameController.dispose();
    teamBNameController.dispose();
    super.onClose();
  }

  void _loadFixtures() {
    isLoading.value = true;
    // For admin, we should get all fixtures. We use getFixtures from repo.
    _fixturesSub = fixtureRepository.getTodaysFixtures().listen((data) {
      // NOTE: getTodaysFixtures is a placeholder for all fixtures for MVP
      fixtures.value = data;
      isLoading.value = false;
    });
  }

  Future<void> addFixture() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final fixture = Fixture(
        id: "",
        tournamentId: "demo_tournament", // Placeholder
        teamAId: "demo_team_a",
        teamBId: "demo_team_b",
        teamAName: teamANameController.text.trim(),
        teamBName: teamBNameController.text.trim(),
        date: DateTime.now(),
        status: "upcoming",
      );

      await createFixtureUseCase.execute(fixture);
      
      Get.back(); // Close dialog
      SnackbarUtils.showSuccess("Fixture added successfully");
      
      teamANameController.clear();
      teamBNameController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
