import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN PAGE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Here there shold be a Login if we only had one',
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text(
                'Go to Home',
              ),
            )
          ],
        ),
      ),
    );
  }
}
