import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class TwoColumnsLayout extends StatelessWidget {
  const TwoColumnsLayout({
    required this.leftChild,
    required this.rightChild,
    super.key,
  });

  final Widget leftChild;
  final Widget rightChild;

  @override
  Widget build(BuildContext context) {
    return context.breakpoint >= LayoutBreakpoint.md
        ? Row(
            children: [
              leftChild,
              rightChild,
            ],
          )
        : Stack(
            children: [
              FractionallySizedBox(
                heightFactor: 0.5,
                child: Row(
                  children: [
                    leftChild,
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    Expanded(
                      flex: 5,
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.surface,
                        child: rightChild,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
