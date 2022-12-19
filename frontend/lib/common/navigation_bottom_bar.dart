import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBottomBar extends StatelessWidget {
  const NavigationBottomBar({
    required this.currentPath,
    required this.currentUser,
    super.key,
  });

  final String currentPath;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    final routes = RouteUtils.getNavigationRoutes(currentUser);

    return NavigationBar(
      destinations: routes
          .map(
            (e) => NavigationDestination(
              icon: Icon(
                e.icon,
              ),
              label: e.label,
            ),
          )
          .toList(),
      onDestinationSelected: (value) => currentPath != routes[value].path
          ? GoRouter.of(context).go(routes[value].path)
          : null,
      selectedIndex: routes
          .firstWhere(
            (r) => r.path == currentPath,
            orElse: () => routes.first,
          )
          .index,
    );
  }
}
