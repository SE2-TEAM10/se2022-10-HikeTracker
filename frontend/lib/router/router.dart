import 'package:HikeTracker/common/main_scaffold.dart';
import 'package:HikeTracker/common/sub_scaffold.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/add_hut/add_hut.dart';
import 'package:HikeTracker/pages/add_parking/add_parking.dart';
import 'package:HikeTracker/pages/hike_detail/hike_detail_page.dart';
import 'package:HikeTracker/pages/pages.dart';
import 'package:HikeTracker/pages/signup/signup.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter getRouter({
  required RestClient client,
  required bool showSplash,
  required User? currentUser,
  required Function onLogged,
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
          child: child,
        ),
        routes: [
          GoRoute(
            path: HIKES,
            pageBuilder: (context, state) => NoTransitionPage(
              child: Home(
                client: client,
              ),
            ),
            routes: [
              GoRoute(
                path: ':hikeID',
                pageBuilder: (context, state) => CustomTransitionPage(
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(opacity: animation, child: child),
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
          if (currentUser != null)
            GoRoute(
              path: PROFILE,
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('PROFILE PAGE: ${currentUser.name}'),
                        TextButton.icon(
                          onPressed: () async {
                            await client.delete(
                              api: 'sessions/current',
                            );
                            onLogged(null);
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        )
                      ],
                    ),
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
