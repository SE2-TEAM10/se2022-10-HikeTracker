import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

//ROUTES
const HOME = '/';
const LOGIN = '/login';
const LOADING = '/loading';
const HIKE_DETAIL = '/hike/:hikeID';
const PROFILE = '/profile';
const HIKE_ADD = '/add';

class Route {
  Route({
    required this.index,
    required this.label,
    required this.path,
    required this.icon,
  });

  final int index;
  final String label;
  final String path;
  final IconData icon;
}

class RouteUtils {
  static List<Route> getNavigationRoutes(User? currentUser) {
    if (currentUser == null) {
      return NOT_LOGGED_NAVIGATION_BAR_ROUTES;
    }

    switch (currentUser.role) {
      case UserRole.LocalGuide:
        return LOCAL_GUIDE_NAVIGATION_BAR_ROUTES;
      default:
        return NOT_LOGGED_NAVIGATION_BAR_ROUTES;
    }
  }
}

final NOT_LOGGED_NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Home',
    path: HOME,
    icon: Icons.home_outlined,
  ),
  Route(
    index: 1,
    label: 'Login',
    path: LOGIN,
    icon: Icons.login_outlined,
  ),
];

final LOCAL_GUIDE_NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Home',
    path: HOME,
    icon: Icons.home_outlined,
  ),
  Route(
    index: 1,
    label: 'Profile',
    path: PROFILE,
    icon: Icons.person_outline,
  ),
  Route(
    index: 2,
    label: 'Add Hike',
    path: HIKE_ADD,
    icon: Icons.add,
  ),
];
