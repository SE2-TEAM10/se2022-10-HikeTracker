import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
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
    initialLocation: HOME,
    routes: <GoRoute>[
      GoRoute(
        path: HOME,
        builder: (BuildContext context, GoRouterState state) {
          return Home(
            client: client,
          );
        },
      ),
      GoRoute(
        path: LOGIN,
        builder: (BuildContext context, GoRouterState state) {
          return Login(
            client: client,
            onLogged: onLogged,
          );
        },
      ),
      GoRoute(
        path: LOADING,
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    ],
    redirect: (context, state) {
      if (showSplash) {
        return LOADING;
      } else if (!showSplash && isLogged && state.location == '/login') {
        return HOME;
      } else if (!showSplash && state.location == '/loading') {
        return HOME;
      } else {
        return null;
      }
    },
  );
}
