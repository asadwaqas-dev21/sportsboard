import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";

class TeamController extends GetxController {
  final TeamRepository teamRepository;

  TeamController({required this.teamRepository});

  final RxList<Team> teams = <Team>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  StreamSubscription? _teamsSub;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final captainNameController = TextEditingController();

  @override
  void onClose() {
    _teamsSub?.cancel();
    nameController.dispose();
    captainNameController.dispose();
    super.onClose();
  }

  void loadTeams(String tournamentId) {
    isLoading.value = true;
    _teamsSub?.cancel();
    _teamsSub = teamRepository.getTeams(tournamentId: tournamentId).listen((data) {
      teams.value = data;
      isLoading.value = false;
    });
  }

  Future<void> saveTeam(String tournamentId) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final team = Team(
        id: "",
        tournamentId: tournamentId,
        name: nameController.text.trim(),
        captainName: captainNameController.text.trim(),
      );

      await teamRepository.addTeam(team);
      Get.back();
      SnackbarUtils.showSuccess("Team added successfully");
      nameController.clear();
      captainNameController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
