import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:HikeTracker/pages/completedHikes/filtered_cards_layout.dart';
//import 'package:HikeTracker/pages/completedHikes/widget/filter_tab.dart';
//import 'package:HikeTracker/pages/completedHikes/models/filter.dart';
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

  @override
  void initState() {
    super.initState();
  }


   @override
  Widget build(BuildContext context) {
     return FilteredCardsLayout(
      Table: CompletedHikesTable(
        client: widget.client,
        user: widget.user,
      ),
    );  
  }
}
