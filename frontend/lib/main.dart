import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/rest_client.dart';
import 'package:frontend/router.dart';
import 'package:layout/layout.dart';

void main() async {
  await dotenv.load(fileName: "../.env");
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
  bool isLogged = false;

  @override
  void initState() {
    widget.client.get(api: 'sessions/current').then((value) {
      setState(() {
        isLogged = json.decode(value.body)['error'] != null ? false : true;
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
          isLogged: isLogged,
          onLogged: (val) => setState(() => isLogged = val),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
