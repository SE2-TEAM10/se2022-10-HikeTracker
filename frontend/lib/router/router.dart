import 'package:HikeTracker/common/main_scaffold.dart';
import 'package:HikeTracker/common/sub_scaffold.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hikes/hike_detail/hike_detail_page.dart';
import 'package:HikeTracker/pages/pages.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter getRouter({
  required RestClient client,
  required bool showSplash,
  required User? currentUser,
  required Function onLogged,
  required Function onThemeChanged,
}) {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _mainShellNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    initialLocation: HIKES,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: HOME,
        redirect: (_, __) => HIKES,
      ),
      ShellRoute(
        navigatorKey: _mainShellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            MainScaffold(
          currentPath: state.path!,
          currentUser: currentUser,
          onThemeChanged: onThemeChanged,
          child: child,
        ),
        routes: [
          GoRoute(
            path: HIKES,
            pageBuilder: (context, state) => NoTransitionPage(
              child: Hikes(
                client: client,
                user: currentUser,
              ),
            ),
            routes: [
              GoRoute(
                path: ':hikeID',
                pageBuilder: (context, state) => NoTransitionPage(
                  child: HikeDetail(
                    client: client,
                    hikeID: int.tryParse(state.params['hikeID'] ?? '0') ?? 0,
                    user: currentUser,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: HUTS,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(
                child: HutsPage(
                  client: client,
                ),
              );
            },
          ),
          GoRoute(
            path: COMPLETED_HIKES,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return NoTransitionPage(
                child: Completedhikes(
                  client: client,
                ),
              );
            },
          ),
          if (currentUser != null)
            GoRoute(
              path: PROFILE,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                  child: ProfilePage(
                    client: client,
                    onLogged: onLogged,
                    user: currentUser,
                  ),
                );
              },
            ),
        ],
      ),
      if (currentUser == null)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
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
      if (currentUser == null)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: SIGNUP,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: Signup(
                client: client,
                onLogged: onLogged,
              ),
            );
          },
        ),
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: HIKE_ADD,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: AddHike(
                client: client,
              ),
            );
          },
        ),
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: HUT_ADD,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: AddHut(
                client: client,
              ),
            );
          },
        ),
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: PARKING_ADD,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: AddParking(
                client: client,
              ),
            );
          },
        ),
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: REFERENCE_POINT_ADD,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
              child: AddReferencePoint(
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
