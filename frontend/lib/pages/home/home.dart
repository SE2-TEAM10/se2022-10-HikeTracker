import 'package:flutter/material.dart';
import 'package:frontend/pages/home/filter.dart';
import 'package:frontend/pages/home/hike_table.dart';
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
    setState(() => filter = f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.breakpoint > LayoutBreakpoint.sm
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
          : Column(
              children: [
                FilterTab(
                  filterHikes: filterHikes,
                ),
                Expanded(
                  child: HikesTable(
                    client: widget.client,
                    filter: filter,
                  ),
                ),
              ],
            ),
    );
  }
}
