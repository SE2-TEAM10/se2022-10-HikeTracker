//import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';

class FilteredCardsLayout extends StatefulWidget {
  const FilteredCardsLayout({
    required this.Table,
    super.key,
  });

  final Widget Table;

  @override
  State<FilteredCardsLayout> createState() => _FilteredCardsState();
}

class _FilteredCardsState extends State<FilteredCardsLayout> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.Table,
      ],
    );
  }
}
