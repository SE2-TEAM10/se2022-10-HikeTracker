import 'package:flutter/material.dart';

//ROUTES
const HOME = '/';
const LOGIN = '/login';
const LOADING = '/loading';
const HIKE_DETAIL = '/hike/:hikeID';

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

final NAVIGATION_BAR_ROUTES = [
  Route(
    index: 0,
    label: 'Home',
    path: HOME,
    icon: Icons.home,
  ),
  Route(
    index: 1,
    label: 'Login',
    path: LOGIN,
    icon: Icons.login,
  ),
];
