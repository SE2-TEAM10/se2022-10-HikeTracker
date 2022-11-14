import 'package:flutter/material.dart';
import 'package:frontend/common/navigation_side_bar.dart';
import 'package:frontend/pages/home/hike_table.dart';
import 'package:frontend/pages/home/models/filter.dart';
import 'package:frontend/pages/home/widget/filter_tab.dart';
import 'package:frontend/rest_client.dart';
import 'package:layout/layout.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.client,
  });

  final RestClient client;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Filter filter;

  @override
  void initState() {
    filter = Filter();
    super.initState();
  }

  void filterHikes(Filter f) {
    Navigator.of(context).pop();
    setState(() => filter = f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: context.breakpoint <= LayoutBreakpoint.sm
          ? FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Center(
                child: Icon(
                  filter.isEmpty()
                      ? Icons.filter_alt_outlined
                      : Icons.filter_alt_off_outlined,
                  size: 32,
                ),
              ),
              onPressed: () => filter.isEmpty()
                  ? showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: FilterTab(
                          filterHikes: filterHikes,
                        ),
                      ),
                    )
                  : setState(() => filter = Filter()),
            )
          : null,
      body: Row(
        children: [
          if (context.breakpoint > LayoutBreakpoint.sm) NavigationSideBar(),
          Expanded(
            child: context.breakpoint > LayoutBreakpoint.sm
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FilterTab(
                          filterHikes: filterHikes,
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: HikesTable(
                            client: widget.client,
                            filter: filter,
                          ),
                        )
                      ],
                    ),
                  )
                : HikesTable(
                    client: widget.client,
                    filter: filter,
                  ),
          ),
        ],
      ),
    );
  }
}
