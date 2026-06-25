import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:sportsboard/app/bindings/app_binding.dart";
import "package:sportsboard/app/routes/app_pages.dart";
import "package:sportsboard/app/routes/app_routes.dart";
import "package:sportsboard/core/theme/app_theme.dart";
import "package:sportsboard/core/theme/theme_controller.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) {
        final isDark = themeController.isDarkMode;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
          child: GetMaterialApp(
            title: "SportsBoard",
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.themeMode,
            initialBinding: AppBinding(),
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
