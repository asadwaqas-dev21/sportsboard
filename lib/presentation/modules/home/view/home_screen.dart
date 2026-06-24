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

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = Get.find<AuthRepository>().isLoggedIn;

    return Obx(() {
      final index = controller.currentIndex.value;
      final isLargeScreen = MediaQuery.of(context).size.width >= 768;

      // Determine main body content
      final Widget mainContent;
      if (index == 0) {
        mainContent = const HomeDashboard();
      } else {
        mainContent = IndexedStack(
          index: index - 1,
          children: const [
            SportsScreen(),
            FixturesScreen(),
            ResultsListScreen(),
            SettingsScreen(),
          ],
        );
      }

      // Determine appBar
      PreferredSizeWidget? appBar;
      if (index > 0) {
        appBar = AppBar(
          title: Text(_getTitle(index)),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () => Get.toNamed(AppRoutes.adminDashboard),
              ),
          ],
        );
      }

      if (isLargeScreen) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: appBar,
          body: Row(
            children: [
              _buildNavigationRail(context),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: SafeArea(child: mainContent)),
            ],
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: appBar,
          body: SafeArea(child: mainContent),
          bottomNavigationBar: _buildBottomNav(context),
        );
      }
    });
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final navBarBgColor =
        theme.navigationBarTheme.backgroundColor ?? theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: navBarBgColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        elevation: 0,
        selectedIndex: controller.currentIndex.value,
        onDestinationSelected: controller.changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            selectedIcon: Icon(Iconsax.home_15),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Iconsax.category),
            selectedIcon: Icon(Iconsax.category5),
            label: "Sports",
          ),
          NavigationDestination(
            icon: Icon(Iconsax.calendar_1),
            selectedIcon: Icon(Iconsax.calendar5),
            label: "Fixtures",
          ),
          NavigationDestination(
            icon: Icon(Iconsax.chart_1),
            selectedIcon: Icon(Iconsax.chart_15),
            label: "Results",
          ),
          NavigationDestination(
            icon: Icon(Iconsax.setting_2),
            selectedIcon: Icon(Iconsax.setting_21),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      selectedIndex: controller.currentIndex.value,
      onDestinationSelected: controller.changePage,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Iconsax.home),
          selectedIcon: Icon(Iconsax.home_15),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.category),
          selectedIcon: Icon(Iconsax.category5),
          label: Text("Sports"),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.calendar_1),
          selectedIcon: Icon(Iconsax.calendar5),
          label: Text("Fixtures"),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.chart_1),
          selectedIcon: Icon(Iconsax.chart_15),
          label: Text("Results"),
        ),
        NavigationRailDestination(
          icon: Icon(Iconsax.setting_2),
          selectedIcon: Icon(Iconsax.setting_21),
          label: Text("Settings"),
        ),
      ],
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return "Sports";
      case 2:
        return "Fixtures";
      case 3:
        return "Results";
      case 4:
        return "Settings";
      default:
        return "SportsBoard";
    }
  }
}
