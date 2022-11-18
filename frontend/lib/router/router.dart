import 'package:flutter/material.dart';
import 'package:frontend/common/main_scaffold.dart';
import 'package:frontend/common/sub_scaffold.dart';
import 'package:frontend/router/constants.dart';
import 'package:frontend/utils/rest_client.dart';
import 'package:go_router/go_router.dart';

import '../pages/pages.dart';

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
          return MainScaffold(
            currentPath: state.path!,
            child: Home(
              client: client,
            ),
          );
        },
      ),
      GoRoute(
        path: LOGIN,
        builder: (BuildContext context, GoRouterState state) {
          return SubScaffold(
            child: Login(
              client: client,
              onLogged: onLogged,
            ),
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
      GoRoute(
        path: HIKE_DETAIL,
        builder: (BuildContext context, GoRouterState state) {
          return SubScaffold(
            child: Center(
              child: Text('DETAIL PAGE FOR HIKE: ${state.params['hikeID']}'),
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
