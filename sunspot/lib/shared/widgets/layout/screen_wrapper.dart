import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/core/theme/app_spacing.dart';
import 'package:sunspot/shared/widgets/navigation/app_drawer.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? appBarTitleColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showDrawer;
  final String? userRole;
  final String? userName;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.appBarTitleColor,
    this.actions,
    this.leading,
    this.showDrawer = false,
    this.userRole,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Scaffold(
      drawer: showDrawer && userRole != null && userName != null
          ? AppDrawer(
              currentRoute: currentRoute,
              userRole: userRole!,
              userName: userName!,
            )
          : null,
      appBar: title != null
          ? AppBar(
              title: Text(
                title!,
                style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  color:
                      appBarTitleColor ??
                      (Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
                ),
              ),
              leading: leading,
              actions: actions,
              automaticallyImplyLeading: showDrawer && leading == null,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
