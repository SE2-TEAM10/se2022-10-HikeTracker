import 'package:flutter/material.dart';
import 'package:frontend/router/constants.dart';
import 'package:go_router/go_router.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({
    required this.currentPath,
    Key? key,
  }) : super(key: key);

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      onDestinationSelected: (value) =>
          currentPath != NAVIGATION_BAR_ROUTES[value].path
              ? GoRouter.of(context).push(NAVIGATION_BAR_ROUTES[value].path)
              : null,
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0.0,
      destinations: NAVIGATION_BAR_ROUTES
          .map(
            (e) => NavigationRailDestination(
              icon: Icon(e.icon),
              label: Text(e.label),
            ),
          )
          .toList(),
      selectedIndex:
          NAVIGATION_BAR_ROUTES.firstWhere((r) => r.path == currentPath).index,
    );
  }
}
