import 'package:HikeTracker/common/filtered_cards_layout.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/huts/models/filter.dart';
import 'package:HikeTracker/pages/huts/widget/filter_tab.dart';
import 'package:HikeTracker/pages/huts/widget/hut_table.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';

class HutsPage extends StatefulWidget {
  const HutsPage({
    required this.client,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;

  @override
  State<HutsPage> createState() => _HutsState();
}

class _HutsState extends State<HutsPage> {
  late Filter filter;
  late HutsTableController tableController;

  @override
  void initState() {
    tableController = HutsTableController();
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
        filterHuts: filterHuts,
        client: widget.client,
        currentFilter: filter,
      ),
      Table: HutsTable(
        client: widget.client,
        filter: filter,
        user: widget.user,
        controller: tableController,
      ),
    );
  }
}
