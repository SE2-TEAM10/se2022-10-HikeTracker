import 'package:flutter/material.dart';
import 'package:frontend/pages/home/models/filter.dart';
import 'package:frontend/pages/home/widget/filter_tab.dart';
import 'package:frontend/pages/home/widget/hike_table.dart';
import 'package:frontend/utils/rest_client.dart';
import 'package:layout/layout.dart';

class Home extends StatefulWidget {
  const Home({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Filter filter;
  late bool showFilter;

  @override
  void initState() {
    filter = Filter();
    showFilter = false;
    super.initState();
  }

  void filterHikes(Filter f) {
    setState(() => filter = f);
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
                              children: [
                                FilterTab(
                                  filterHikes: filterHikes,
                                  client: widget.client,
                                  currentFilter: filter,
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: HikesTable(
                      client: widget.client,
                      filter: filter,
                    ),
                  ),
                ],
              )
            : HikesTable(
                client: widget.client,
                filter: filter,
              ),
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
                        FilterTab(
                          filterHikes: filterHikes,
                          client: widget.client,
                          currentFilter: filter,
                        )
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
