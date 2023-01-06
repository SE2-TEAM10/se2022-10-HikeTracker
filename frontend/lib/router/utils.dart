import 'package:HikeTracker/models/user.dart';
import 'package:flutter/material.dart';

//ROUTES
const HOME = '/';
const HIKES = '/hikes';
const LOGIN = '/login';
const SIGNUP = '/signup';
const LOADING = '/loading';
const HIKE_DETAIL = '$HIKES/:hikeID';
const PROFILE = '/profile';
const HIKE_ADD = '/hike/add';
const HUT_ADD = '/hut/add';
const PARKING_ADD = '/parking/add';
const REFERENCE_POINT_ADD = '/referencePoint/add';
const HUTS = '/huts';
const COMPLETED_HIKES = '/completedHikes';
const HIKING = '/hiking';

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
      case UserRole.Hiker:
        return HIKER_NAVIGATION_BAR_ROUTES;
      default:
        return NOT_LOGGED_NAVIGATION_BAR_ROUTES;
    }
  }
}

final NOT_LOGGED_NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Hikes',
    path: HIKES,
    icon: Icons.home_outlined,
  ),
  Route(
    index: 1,
    label: 'Login',
    path: LOGIN,
    icon: Icons.login_outlined,
  ),
  Route(
    index: 2,
    label: 'Signup',
    path: SIGNUP,
    icon: Icons.person_add_alt,
  ),
];

final SUPPORT_ROUTE = Route(
  index: 0,
  label: '',
  path: '',
  icon: Icons.label,
);

final LOCAL_GUIDE_NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Hikes',
    path: HIKES,
    icon: Icons.home_outlined,
  ),
  Route(
    index: 1,
    label: 'Add Hike',
    path: HIKE_ADD,
    icon: Icons.add,
  ),
  Route(
    index: 2,
    label: 'Add Hut',
    path: HUT_ADD,
    icon: Icons.add_home,
  ),
  Route(
    index: 3,
    label: 'Add Parking',
    path: PARKING_ADD,
    icon: Icons.local_parking,
  ),
  Route(
    index: 4,
    label: 'Add R.Point',
    path: REFERENCE_POINT_ADD,
    icon: Icons.add_location_alt,
  ),
  Route(
    index: 5,
    label: 'Profile',
    path: PROFILE,
    icon: Icons.person_outline,
  ),
];

final HIKER_NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Hikes',
    path: HIKES,
    icon: Icons.home_outlined,
  ),
  Route(
    index: 1,
    label: 'Huts',
    path: HUTS,
    icon: Icons.home_work,
  ),
  Route(
    index: 2,
    label: 'Profile',
    path: PROFILE,
    icon: Icons.person_outline,
  ),
  Route(
    index: 3,
    label: 'Completed hikes',
    path: COMPLETED_HIKES,
    icon: Icons.check_circle_outline,
  ),
];
