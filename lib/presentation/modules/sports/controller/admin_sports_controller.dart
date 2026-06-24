import "dart:async";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:sportsboard/core/utils/snackbar_utils.dart";
import "package:sportsboard/domain/entities/sport.dart";
import "package:sportsboard/domain/usecases/sport/create_sport_usecase.dart";
import "package:sportsboard/domain/usecases/sport/get_sports_usecase.dart";

class AdminSportsController extends GetxController {
  final GetSportsUseCase getSportsUseCase;
  final CreateSportUseCase createSportUseCase;

  AdminSportsController({
    required this.getSportsUseCase,
    required this.createSportUseCase,
  });

  final RxList<Sport> sports = <Sport>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  StreamSubscription? _sportsSub;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final typeController = TextEditingController(); // e.g., cricket, football

  @override
  void onInit() {
    super.onInit();
    _loadSports();
  }

  @override
  void onClose() {
    _sportsSub?.cancel();
    nameController.dispose();
    typeController.dispose();
    super.onClose();
  }

  void _loadSports() {
    isLoading.value = true;
    _sportsSub = getSportsUseCase.execute().listen((data) {
      sports.value = data;
      isLoading.value = false;
    });
  }

  Future<void> addSport() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      final sport = Sport(
        id: "", // Auto-generated
        name: nameController.text.trim(),
        iconName: "cup", // Default icon name
        type: typeController.text.trim(),
      );

      await createSportUseCase.execute(sport);

      Get.back(); // Close dialog
      SnackbarUtils.showSuccess("Sport added successfully");

      nameController.clear();
      typeController.clear();
    } catch (e) {
      SnackbarUtils.showError(e.toString());
    } finally {
      isSaving.value = false;
    }
  }
}
