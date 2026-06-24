import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/player.dart";
import "package:sportsboard/domain/repositories/player_repository.dart";

class PlayerController extends GetxController {
  final PlayerRepository playerRepository;

  PlayerController({required this.playerRepository});

  final RxList<Player> players = <Player>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  StreamSubscription? _playersSub;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final classController = TextEditingController();
  final rollNoController = TextEditingController();

  @override
  void onClose() {
    _playersSub?.cancel();
    nameController.dispose();
    classController.dispose();
    rollNoController.dispose();
    super.onClose();
  }

  void loadPlayers(String teamId) {
    isLoading.value = true;
    _playersSub?.cancel();
    _playersSub = playerRepository.getPlayers(teamId: teamId).listen((data) {
      players.value = data;
      isLoading.value = false;
    });
  }

  Future<void> savePlayer(String teamId, String teamName, String sportId) async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final player = Player(
        id: "",
        teamId: teamId,
        teamName: teamName,
        sportId: sportId,
        name: nameController.text.trim(),
        className: classController.text.trim(),
        rollNo: rollNoController.text.trim(),
      );

      await playerRepository.addPlayer(player);
      Get.back();
      SnackbarUtils.showSuccess("Player added successfully");
      
      nameController.clear();
      classController.clear();
      rollNoController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
