import 'dart:math';

import 'package:HikeTracker/common/time_field.dart';
import 'package:HikeTracker/pages/huts/models/filter.dart';
import 'package:HikeTracker/pages/huts/models/hut.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:layout/layout.dart';

class FilterTab extends StatefulWidget {
  const FilterTab({
    required this.filterHuts,
    required this.client,
    this.currentFilter,
    super.key,
  });

  final Function filterHuts;
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
      api: 'hutWithFilters',
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
          final huts = Huts.fromJson(snapshot.data!.body).results;
          final minAlt =
              huts!.map((e) => e.altitude).toList().reduce(min).toDouble();
          final maxAlt =
              huts.map((e) => e.altitude).toList().reduce(max).toDouble();
          final minBed =
              huts.map((e) => e.bednum).toList().reduce(min).toDouble();
          final maxBed =
              huts.map((e) => e.bednum).toList().reduce(max).toDouble();
          final cities =
              huts.map((e) => e.city).whereType<String>().toSet().toList();
          final provinces =
              huts.map((e) => e.province).whereType<String>().toSet().toList();

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
                          'Altitude: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'from ${filter.minaltitude ?? minAlt}m to ${filter.maxaltitude ?? maxAlt}m',
                      ),
                    ],
                  ),
                  RangeSlider(
                    min: minAlt,
                    max: maxAlt,
                    values: RangeValues(
                      double.tryParse(filter.minaltitude ?? '') ?? minAlt,
                      double.tryParse(filter.maxaltitude ?? '') ?? maxAlt,
                    ),
                    onChanged: (value) => setState(
                      () {
                        filter.minaltitude = value.start.floor().toString();
                        filter.maxaltitude = value.end.floor().toString();
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Beds number: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'from ${filter.minbed ?? minBed} to ${filter.maxbed ?? maxBed}',
                      ),
                    ],
                  ),
                  RangeSlider(
                    min: minBed,
                    max: maxBed,
                    values: RangeValues(
                      double.tryParse(filter.minbed ?? '') ?? minBed,
                      double.tryParse(filter.maxbed ?? '') ?? maxBed,
                    ),
                    onChanged: (value) => setState(
                      () {
                        filter.minbed = value.start.floor().toString();
                        filter.maxbed = value.end.floor().toString();
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TimeField(
                          label: 'Minimum Opening time',
                          startingTime: filter.minOpTime,
                          onChange: (newTime) => {
                            setState(() {
                              filter.minOpTime =
                                  '${newTime.hour}:${newTime.minute}';
                            })
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: TimeField(
                          label: 'Maximum Opening time',
                          startingTime: filter.maxOpTime,
                          onChange: (newTime) => {
                            setState(() {
                              filter.maxOpTime =
                                  '${newTime.hour}:${newTime.minute}';
                            })
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TimeField(
                          label: 'Minimum Closing time',
                          startingTime: filter.minEdTime,
                          onChange: (newTime) => {
                            setState(() {
                              filter.minEdTime =
                                  '${newTime.hour}:${newTime.minute}';
                            })
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: TimeField(
                          label: 'Maximum Closing time',
                          startingTime: filter.maxEdTime,
                          onChange: (newTime) => {
                            setState(() {
                              filter.maxEdTime =
                                  '${newTime.hour}:${newTime.minute}';
                            })
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
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
                            if (context.breakpoint <= LayoutBreakpoint.sm) {
                              Navigator.of(context).pop();
                            }
                            filter = Filter();
                            widget.filterHuts(filter);
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
                          if (context.breakpoint <= LayoutBreakpoint.sm) {
                            Navigator.of(context).pop();
                          }
                          widget.filterHuts(filter);
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
