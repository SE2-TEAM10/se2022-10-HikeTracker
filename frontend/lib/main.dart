import 'dart:convert';

import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/router/router.dart';
import 'package:HikeTracker/theme/theme.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:layout/layout.dart';

void main() async {
  await dotenv.load();
  final client = RestClient();

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatefulWidget {
  final RestClient client;

  const MyApp({required this.client, super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showSplash = true;
  bool hikeOnGoing = false;
  User? currentUser;
  ThemeMode theme = ThemeMode.light;

  @override
  void initState() {
    widget.client.get(api: 'sessions/current').then((value) async {
      setState(() {
        currentUser = json.decode(value.body)['error'] == null
            ? User.fromJson(value.body)
            : null;
        showSplash = false;
      });

      if (currentUser != null) {
        final res = await widget.client.get(api: 'getOnGoingHike');
        setState(() {
          hikeOnGoing = res.body.isNotEmpty;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp.router(
        routerConfig: getRouter(
          hikeOnGoing: hikeOnGoing,
          client: widget.client,
          showSplash: showSplash,
          currentUser: currentUser,
          onLogged: (User? val) async {
            setState(() => currentUser = val);
            if (val != null) {
              final res = await widget.client.get(api: 'getOnGoingHike');
              setState(() {
                hikeOnGoing = res.body.isNotEmpty;
              });
            }
          },
          onHikeStart: () async {
            final res = await widget.client.get(api: 'getOnGoingHike');
            setState(() {
              hikeOnGoing = res.body.isNotEmpty;
            });
          },
          onThemeChanged: () => setState(
            () => theme =
                theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Hike Tracker',
        themeMode: theme,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
      ),
    );
  }
}
