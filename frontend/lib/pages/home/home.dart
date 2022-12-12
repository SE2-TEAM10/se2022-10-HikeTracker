import 'package:HikeTracker/common/filtered_cards_layout.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/home/models/filter.dart';
import 'package:HikeTracker/pages/home/widget/filter_tab.dart';
import 'package:HikeTracker/pages/home/widget/hike_table.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    required this.client,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;

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
      ),
    );
  }
}
