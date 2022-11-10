import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
            const Text(
              'Welcome to the Hike tracker!!!',
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/login'),
              child: const Text(
                'Go to login',
              ),
            )
          ],
        ),
      ),
    );
  }
}
