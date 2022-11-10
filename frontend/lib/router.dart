import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/pages.dart';

final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const Home();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const Login();
        },
      ),
    ],
    errorBuilder: (context, state) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        router.go('/');
      });
      return const SizedBox.shrink();
    });
