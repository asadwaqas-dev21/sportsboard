import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/domain/repositories/auth_repository.dart";
import "package:sportsboard/presentation/modules/home/controller/home_controller.dart";
import "package:sportsboard/presentation/modules/home/view/widgets/home_dashboard.dart";
import "package:sportsboard/presentation/modules/sports/view/sports_screen.dart";
import "package:sportsboard/presentation/modules/fixtures/view/fixtures_screen.dart";
import "package:sportsboard/presentation/modules/result/view/results_list_screen.dart";
import "package:sportsboard/presentation/modules/settings/view/settings_screen.dart";

const _titles = ["SportsBoard", "Sports", "Fixtures", "Results", "Settings"];

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = Get.find<AuthRepository>().isLoggedIn;

    return Obx(() {
      final index = controller.currentIndex.value;

      return Scaffold(
        appBar: index == 0
            ? null
            : AppBar(
                title: Text(_titles[index]),
                centerTitle: false,
                automaticallyImplyLeading: false,
                actions: [
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings_outlined),
                      onPressed: () => Get.toNamed(AppRoutes.adminDashboard),
                    ),
                ],
              ),
        body: SafeArea(
          child: index == 0
              ? const HomeDashboard()
              : IndexedStack(
                  index: index - 1,
                  children: const [
                    SportsScreen(),
                    FixturesScreen(),
                    ResultsListScreen(),
                    SettingsScreen(),
                  ],
                ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              activeIcon: Icon(Iconsax.home_15),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.category),
              activeIcon: Icon(Iconsax.category5),
              label: "Sports",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.calendar_1),
              activeIcon: Icon(Iconsax.calendar5),
              label: "Fixtures",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.chart_1),
              activeIcon: Icon(Iconsax.chart_15),
              label: "Results",
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.setting_2),
              activeIcon: Icon(Iconsax.setting_21),
              label: "Settings",
            ),
          ],
        ),
      );
    });
  }
}
