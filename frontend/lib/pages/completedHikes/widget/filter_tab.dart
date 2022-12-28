import 'dart:math';

import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/pages/completedHikes/models/filter.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FilterTab extends StatefulWidget {
  const FilterTab({
    required this.filterHikes,
    required this.client,
    this.currentFilter,
    super.key,
  });

  final Function filterHikes;
  final Filter? currentFilter;
  final RestClient client;

  @override
  State<StatefulWidget> createState() => _FilterTab();
}

class _FilterTab extends State<FilterTab> {
  late GlobalKey<FormState> _formKey;
  late Filter filter;
  late Future<Response> future;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    filter = widget.currentFilter ?? Filter();
    future = widget.client.get(
      api: 'hike',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          final hikes = Hikes.fromJson(snapshot.data!.body).results;
          final minAsc =
              hikes!.map((e) => e.ascent).toList().reduce(min).toDouble();
          final maxAsc =
              hikes.map((e) => e.ascent).toList().reduce(max).toDouble();
          final minLength =
              hikes.map((e) => e.length).toList().reduce(min).toDouble();
          final maxLength =
              hikes.map((e) => e.length).toList().reduce(max).toDouble();
          final difficulties = [
            'ALL',
            ...hikes.map((e) => e.difficulty).toSet().toList()
          ];
          final cities = hikes
              .map((e) => e.locations)
              .expand((e) => e)
              .map((e) => e.city)
              .whereType<String>()
              .toSet()
              .toList();
          final provinces = hikes
              .map((e) => e.locations)
              .expand((e) => e)
              .map((e) => e.province)
              .whereType<String>()
              .toSet()
              .toList();

          return Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Ascent: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'from ${filter.startAsc ?? minAsc}m to ${filter.endAsc ?? maxAsc}m',
                      ),
                    ],
                  ),
                  RangeSlider(
                    min: minAsc,
                    max: maxAsc,
                    values: RangeValues(
                      double.tryParse(filter.startAsc ?? '') ?? minAsc,
                      double.tryParse(filter.endAsc ?? '') ?? maxAsc,
                    ),
                    onChanged: (value) => setState(
                      () {
                        filter.startAsc = value.start.floor().toString();
                        filter.endAsc = value.end.floor().toString();
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Length: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'from ${filter.startLen ?? minLength}km to ${filter.endLen ?? maxLength}km',
                      ),
                    ],
                  ),
                  RangeSlider(
                    min: minLength,
                    max: maxLength,
                    values: RangeValues(
                      double.tryParse(filter.startLen ?? '') ?? minLength,
                      double.tryParse(filter.endLen ?? '') ?? maxLength,
                    ),
                    onChanged: (value) => setState(
                      () {
                        filter.startLen = value.start.floor().toString();
                        filter.endLen = value.end.floor().toString();
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Diff.: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: filter.difficulty,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            underline: const SizedBox(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                filter.difficulty = value!;
                              });
                            },
                            items: difficulties
                                .map(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'City: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: filter.city,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            underline: const SizedBox(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                filter.city = value!;
                              });
                            },
                            items: cities
                                .map(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prov.: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: filter.province,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            underline: const SizedBox(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                filter.province = value!;
                              });
                            },
                            items: provinces
                                .map(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (!filter.isEmpty())
                        TextButton(
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () => setState(() {
                            if (context.isMobile) {
                              Navigator.of(context).pop();
                            }
                            filter = Filter();
                            widget.filterHikes(filter);
                          }),
                        ),
                      TextButton(
                        child: const Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          if (context.isMobile) {
                            Navigator.of(context).pop();
                          }
                          widget.filterHikes(filter);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
