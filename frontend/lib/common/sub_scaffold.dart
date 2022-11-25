import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubScaffold extends StatelessWidget {
  const SubScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            final r = GoRouter.of(context);
            r.pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: child,
    );
  }
}
