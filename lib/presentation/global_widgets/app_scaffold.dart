import "package:flutter/material.dart";

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      drawer: drawer,
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        // Remove flexibleSpace to use Theme's default AppBar styles
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
