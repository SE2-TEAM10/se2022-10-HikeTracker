import 'package:HikeTracker/common/navigation_bottom_bar.dart';
import 'package:HikeTracker/common/navigation_side_bar.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.child,
    required this.currentPath,
    required this.currentUser,
    required this.onThemeChanged,
    super.key,
  });

  final Widget child;
  final String currentPath;
  final User? currentUser;
  final Function onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: !context.isMobile
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hike Tracker: ${RouteUtils.getNavigationRoutes(currentUser).firstWhere(
                            (r) => r.path == GoRouter.of(context).location,
                            orElse: () => SUPPORT_ROUTE,
                          ).label}',
                      style: TextStyle(
                        fontSize: 24,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: double.infinity,
        backgroundColor: context.isMobile
            ? Theme.of(context).colorScheme.secondaryContainer
            : Colors.transparent,
        title: context.isMobile
            ? Text(
                'Hike Tracker: ${RouteUtils.getNavigationRoutes(currentUser).firstWhere(
                      (r) => r.path == GoRouter.of(context).location,
                      orElse: () => SUPPORT_ROUTE,
                    ).label}',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      extendBodyBehindAppBar: !context.isMobile,
      body: !context.isMobile
          ? Row(
              children: [
                NavigationSideBar(
                  currentPath: currentPath,
                  currentUser: currentUser,
                  onThemeChanged: onThemeChanged,
                ),
                Expanded(
                  child: child,
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: child,
                ),
                NavigationBottomBar(
                  currentPath: currentPath,
                  currentUser: currentUser,
                ),
              ],
            ),
    );
  }
}
