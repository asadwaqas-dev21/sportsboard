import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/data/models/player_stats_model.dart";
import "package:sportsboard/domain/entities/player.dart";
import "package:sportsboard/domain/entities/player_stats.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/player_repository.dart";
import "package:sportsboard/domain/repositories/sport_repository.dart";
import "package:sportsboard/domain/repositories/team_repository.dart";

class PlayerController extends GetxController {
  final PlayerRepository playerRepository;

  PlayerController({required this.playerRepository});

  final RxList<Player> players = <Player>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  StreamSubscription? _playersSub;
  StreamSubscription? _teamsSub;
  StreamSubscription? _sportsSub;

  final RxList<Team> teamsList = <Team>[].obs;
  final Rxn<Team> selectedTeam = Rxn<Team>();

  final RxList<Sport> sports = <Sport>[].obs;
  final Rxn<Sport> selectedSport = Rxn<Sport>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final classController = TextEditingController();
  final rollNoController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Team) {
      selectedTeam.value = args;
      loadPlayers(teamId: args.id);
    } else {
      loadPlayers();
    }
    _loadTeams();
    _loadSports();
  }

  @override
  void onClose() {
    _playersSub?.cancel();
    _teamsSub?.cancel();
    _sportsSub?.cancel();
    nameController.dispose();
    classController.dispose();
    rollNoController.dispose();
    super.onClose();
  }

  void _loadTeams() {
    _teamsSub?.cancel();
    _teamsSub = Get.find<TeamRepository>().getTeams().listen((data) {
      teamsList.value = data;
      final args = Get.arguments;
      if (args is Team) {
        selectedTeam.value = data.firstWhereOrNull((t) => t.id == args.id);
      } else if (data.isNotEmpty && selectedTeam.value == null) {
        selectedTeam.value = data.first;
      }
    });
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

  void loadPlayers({String? teamId}) {
    isLoading.value = true;
    _playersSub?.cancel();
    _playersSub = playerRepository.getPlayers(teamId: teamId).listen((data) {
      players.value = data;
      isLoading.value = false;
    });
  }

  Future<PlayerStats?> getPlayerStatsForPlayer(String playerId) async {
    final snap = await FirebaseFirestore.instance
        .collection(AppConstants.playerStatsCollection)
        .where("playerId", isEqualTo: playerId)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return PlayerStatsModel.fromFirestore(snap.docs.first);
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
