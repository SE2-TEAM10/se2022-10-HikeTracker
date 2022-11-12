import 'package:flutter/material.dart';
import 'package:frontend/rest_client.dart';
import 'package:go_router/go_router.dart';

import 'pages/pages.dart';

//COMMENTO

GoRouter getRouter({
  required RestClient client,
  required bool showSplash,
  required bool isLogged,
  required Function onLogged,
}) {
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
          return Login(
            client: client,
            onLogged: onLogged,
          );
        },
      ),
      GoRoute(
        path: '/loading',
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //router.go('/');
      });
      return const SizedBox.shrink();
    },
    redirect: (context, state) {
      if (showSplash) {
        return '/loading';
      } else if (!showSplash && !isLogged) {
        return '/login';
      } else if (!showSplash && isLogged && state.location == '/login') {
        return '/';
      } else {
        return null;
      }
    },
  );
}
