import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class FilteredCardsLayout extends StatefulWidget {
  const FilteredCardsLayout({
    required this.FilterTab,
    required this.Table,
    super.key,
  });

  final Widget FilterTab;
  final Widget Table;

  @override
  State<FilteredCardsLayout> createState() => _FilteredCardsState();
}

class _FilteredCardsState extends State<FilteredCardsLayout> {
  late bool showFilter;

  @override
  void initState() {
    showFilter = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        context.breakpoint > LayoutBreakpoint.sm
            ? Row(
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: showFilter ? 300 : 0,
                      child: showFilter
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [widget.FilterTab],
                            )
                          : null,
                    ),
                  ),
                  Expanded(child: widget.Table),
                ],
              )
            : widget.Table,
        Positioned(
          bottom: 32,
          right: 32,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Center(
              child: Icon(
                !showFilter
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt_off_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onPressed: () {
              if (context.breakpoint <= LayoutBreakpoint.sm) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 2,
                            width: 200,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        widget.FilterTab
                      ],
                    ),
                  ),
                );
              } else {
                setState(() {
                  showFilter = !showFilter;
                });
              }
            },
          ),
        )
      ],
    );
  }
}
