import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';

class TwoColumnsLayout extends StatelessWidget {
  const TwoColumnsLayout({
    required this.leftChild,
    required this.rightChild,
    this.leftFlex = 3,
    this.rightFlex = 5,
    this.isNested = false,
    this.hideLeftChild = false,
    this.hideRightChild = false,
    super.key,
  });

  final Widget leftChild;
  final Widget rightChild;
  final int leftFlex;
  final int rightFlex;
  final bool isNested;
  final bool hideLeftChild;
  final bool hideRightChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isNested ? const EdgeInsets.only(top: 64.0) : EdgeInsets.zero,
      child: !context.isMobile
          ? Row(
              children: [
                if (!hideLeftChild)
                  Expanded(
                    flex: leftFlex,
                    child: leftChild,
                  ),
                if (!hideRightChild)
                  Expanded(
                    flex: rightFlex,
                    child: rightChild,
                  ),
              ],
            )
          : Stack(
              children: [
                if (!hideLeftChild)
                  FractionallySizedBox(
                    heightFactor: 0.5,
                    child: Row(
                      children: [
                        Expanded(child: leftChild),
                      ],
                    ),
                  ),
                if (!hideRightChild)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Spacer(
                          flex: leftFlex,
                        ),
                        Expanded(
                          flex: rightFlex,
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.surface,
                            child: SingleChildScrollView(child: rightChild),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
