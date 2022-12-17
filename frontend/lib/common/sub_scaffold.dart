import 'package:HikeTracker/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';

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
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).go(HOME),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      extendBodyBehindAppBar: context.breakpoint < LayoutBreakpoint.md,
      body: child,
    );
  }
}
