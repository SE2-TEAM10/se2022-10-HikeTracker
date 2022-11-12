import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';
import 'package:go_router/go_router.dart';

import 'pages/pages.dart';

//COMMENTO

GoRouter getRouter(RestClient client) {
  return GoRouter(
      initialLocation: '/',
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return Home(
              client: client,
            );
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
          //router.go('/');
        });
        return const SizedBox.shrink();
      });
}
