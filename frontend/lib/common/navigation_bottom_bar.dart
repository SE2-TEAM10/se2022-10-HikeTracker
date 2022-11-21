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

    return BottomNavigationBar(
      items: routes
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              label: e.label,
            ),
          )
          .toList(),
      onTap: (value) => currentPath != routes[value].path
          ? GoRouter.of(context).push(routes[value].path)
          : null,
      currentIndex: routes.firstWhere((r) => r.path == currentPath).index,
    );
  }
}
