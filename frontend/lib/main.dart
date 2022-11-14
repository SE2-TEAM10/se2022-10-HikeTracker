import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/rest_client.dart';
import 'package:frontend/router.dart';
import 'package:layout/layout.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final client = RestClient();

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  final RestClient client;

  const MyApp({required this.client, super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: getRouter(client),
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
