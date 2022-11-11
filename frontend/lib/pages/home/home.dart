import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/home/filter.dart';
import 'package:frontend/rest_client.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.client,
  });

  final RestClient client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME PAGE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeContent(client: client),
            /*const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/login'),
              child: const Text(
                'Go to login',
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
    required this.client,
  });

  final RestClient client;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Filter filter = Filter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterTab(),
        //HikesPage(),
      ],
    );
  }
}
