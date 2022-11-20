import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/router/router.dart';
import 'package:frontend/theme/theme.dart';
import 'package:frontend/utils/rest_client.dart';
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
  User? currentUser;

  @override
  void initState() {
    widget.client.get(api: 'sessions/current').then((value) {
      setState(() {
        currentUser = json.decode(value.body)['error'] == null
            ? User.fromJson(value.body)
            : null;
        showSplash = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp.router(
        routerConfig: getRouter(
          client: widget.client,
          showSplash: showSplash,
          currentUser: currentUser,
          onLogged: (User val) => setState(() => currentUser = val),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
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
