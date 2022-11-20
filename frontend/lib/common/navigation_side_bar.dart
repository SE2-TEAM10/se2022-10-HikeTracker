import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/router/utils.dart';
import 'package:go_router/go_router.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({
    required this.currentPath,
    required this.currentUser,
    super.key,
  });

  final String currentPath;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    final routes = RouteUtils.getNavigationRoutes(currentUser);

    return NavigationRail(
      onDestinationSelected: (value) => currentPath != routes[value].path
          ? GoRouter.of(context).push(routes[value].path)
          : null,
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0.0,
      destinations: routes
          .map(
            (e) => NavigationRailDestination(
              icon: Icon(e.icon),
              label: Text(e.label),
            ),
          )
          .toList(),
      selectedIndex: routes.firstWhere((r) => r.path == currentPath).index,
    );
  }
}
