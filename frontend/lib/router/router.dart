import 'package:flutter/material.dart';
import 'package:frontend/common/main_scaffold.dart';
import 'package:frontend/common/sub_scaffold.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/pages/pages.dart';
import 'package:frontend/router/utils.dart';
import 'package:frontend/utils/rest_client.dart';
import 'package:go_router/go_router.dart';

GoRouter getRouter({
  required RestClient client,
  required bool showSplash,
  required User? currentUser,
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
            currentUser: currentUser,
            child: Home(
              client: client,
            ),
          );
        },
      ),
      if (currentUser == null)
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
      if (currentUser != null)
        GoRoute(
          path: PROFILE,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: Center(
                child: Text('PROFILE PAGE: ${currentUser.name}'),
              ),
            );
          },
        ),
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
          path: HIKE_ADD,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: AddHike(
                client: client,
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
      } else if (!showSplash && state.location == '/loading') {
        return HOME;
      } else {
        return null;
      }
    },
  );
}
