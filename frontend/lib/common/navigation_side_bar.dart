import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:go_router/go_router.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      onDestinationSelected: (value) {
        switch (value) {
          case 0:
            GoRouter.of(context).go(HOME);
            break;
          case 1:
            GoRouter.of(context).go(LOGIN);
            break;
          default:
            GoRouter.of(context).go(HOME);
        }
      },
      labelType: NavigationRailLabelType.all,
      groupAlignment: 0.0,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text(
            'home',
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.login),
          label: Text(
            'login',
          ),
        ),
      ],
      selectedIndex: 0,
    );
  }
}
