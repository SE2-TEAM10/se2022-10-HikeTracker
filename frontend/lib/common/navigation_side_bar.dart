import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({
    required this.currentPath,
    required this.currentUser,
    required this.onThemeChanged,
    super.key,
  });

  final String currentPath;
  final User? currentUser;
  final Function onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final routes = RouteUtils.getNavigationRoutes(currentUser);

    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            backgroundColor: Colors.transparent,
            onDestinationSelected: (value) => currentPath != routes[value].path
                ? GoRouter.of(context).go(routes[value].path)
                : null,
            labelType: NavigationRailLabelType.all,
            groupAlignment: 0.0,
            destinations: routes
                .map(
                  (e) => NavigationRailDestination(
                    icon: Icon(
                      e.icon,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      e.label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
                .toList(),
            selectedIndex: routes
                .firstWhere(
                  (r) => r.path == GoRouter.of(context).location,
                  orElse: () => routes.first,
                )
                .index,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () => onThemeChanged.call(),
            style: IconButton.styleFrom(
              focusColor: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.12),
              highlightColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.12),
              side: BorderSide(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
