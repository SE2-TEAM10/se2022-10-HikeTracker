import 'package:HikeTracker/common/navigation_bottom_bar.dart';
import 'package:HikeTracker/common/navigation_side_bar.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.child,
    required this.currentPath,
    required this.currentUser,
    super.key,
  });

  final Widget child;
  final String currentPath;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.breakpoint > LayoutBreakpoint.sm
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
                      'Hike Tracker',
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
        backgroundColor: context.breakpoint > LayoutBreakpoint.sm
            ? Colors.transparent
            : Theme.of(context).colorScheme.secondaryContainer,
        title: context.breakpoint <= LayoutBreakpoint.sm
            ? Text(
                'Hike Tracker',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      extendBodyBehindAppBar: true,
      body: context.breakpoint > LayoutBreakpoint.sm
          ? Row(
              children: [
                NavigationSideBar(
                  currentPath: currentPath,
                  currentUser: currentUser,
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
