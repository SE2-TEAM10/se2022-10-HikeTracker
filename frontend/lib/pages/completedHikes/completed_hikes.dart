import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:HikeTracker/common/filtered_cards_layout.dart';
import 'package:HikeTracker/pages/completedHikes/widget/filter_tab.dart';
import 'package:HikeTracker/pages/completedHikes/models/filter.dart';
import 'package:HikeTracker/pages/completedHikes/widget/completed_hike_table.dart';
import 'package:flutter/material.dart';

class Completedhikes extends StatefulWidget {
  const Completedhikes({
    required this.client,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;

  @override
  State<Completedhikes> createState() => _CompletedHikesState();
}

class _CompletedHikesState extends State<Completedhikes> {

  late Filter filter;
  late CompletedHikesTableController tableController;

  @override
  void initState() {
    tableController = CompletedHikesTableController();
    filter = Filter();
    super.initState();
  }

  void filterHuts(Filter f) {
    setState(() => filter = f);
    tableController.onFilterChange?.call(f);
  }

   @override
  Widget build(BuildContext context) {
    return FilteredCardsLayout(
      FilterTab: FilterTab(
        filterHikes: filterHuts,
        client: widget.client,
        currentFilter: filter,
      ),
      Table: CompletedHikesTable(
        client: widget.client,
        filter: filter,
        user: widget.user,
        controller: tableController,
      ),
    );
  }
}
