import 'package:HikeTracker/common/main_scaffold.dart';
import 'package:HikeTracker/common/sub_scaffold.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/add_hut/add_hut.dart';
import 'package:HikeTracker/pages/add_parking/add_parking.dart';
import 'package:HikeTracker/pages/hike_detail/hike_detail.dart';
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
      if (currentUser == null)
        GoRoute(
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
      if (currentUser != null)
        GoRoute(
          path: PROFILE,
          builder: (BuildContext context, GoRouterState state) {
            return SubScaffold(
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
      if (currentUser?.role == UserRole.LocalGuide)
        GoRoute(
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
      GoRoute(
        path: HIKE_DETAIL,
        builder: (BuildContext context, GoRouterState state) {
          return SubScaffold(
            child: HikeDetail(
              client: client,
              hikeID: int.tryParse(state.params['hikeID'] ?? '0') ?? 0,
              user: currentUser,
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
