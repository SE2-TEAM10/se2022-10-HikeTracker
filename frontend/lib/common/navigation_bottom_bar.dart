import 'package:flutter/material.dart';
import 'package:frontend/router/constants.dart';
import 'package:go_router/go_router.dart';

class NavigationBottomBar extends StatelessWidget {
  const NavigationBottomBar({
    required this.currentPath,
    Key? key,
  }) : super(key: key);

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: NAVIGATION_BAR_ROUTES
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              label: e.label,
            ),
          )
          .toList(),
      onTap: (value) => currentPath != NAVIGATION_BAR_ROUTES[value].path
          ? GoRouter.of(context).push(NAVIGATION_BAR_ROUTES[value].path)
          : null,
      currentIndex:
          NAVIGATION_BAR_ROUTES.firstWhere((r) => r.path == currentPath).index,
    );
  }
}
