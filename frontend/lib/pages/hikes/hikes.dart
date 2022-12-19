import 'package:HikeTracker/common/filtered_cards_layout.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hikes/models/filter.dart';
import 'package:HikeTracker/pages/hikes/widget/filter_tab.dart';
import 'package:HikeTracker/pages/hikes/widget/hike_table.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';

class Hikes extends StatefulWidget {
  const Hikes({
    required this.client,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;

  @override
  State<Hikes> createState() => _HikesState();
}

class _HikesState extends State<Hikes> {
  late Filter filter;
  late HikesTableController tableController;

  @override
  void initState() {
    filter = Filter();
    tableController = HikesTableController();
    super.initState();
  }

  void filterHikes(Filter f) {
    setState(() => filter = f);
    tableController.onFilterChange?.call(f);
  }

  @override
  Widget build(BuildContext context) {
    tableController.onFilterChange?.call(filter);
    return FilteredCardsLayout(
      FilterTab: FilterTab(
        filterHikes: filterHikes,
        client: widget.client,
        currentFilter: filter,
      ),
      Table: HikesTable(
        client: widget.client,
        filter: filter,
        user: widget.user,
        controller: tableController,
      ),
    );
  }
}
