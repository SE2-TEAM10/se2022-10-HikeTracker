import 'dart:convert';

import 'package:HikeTracker/common/main_scaffold.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hikes/hike_detail/widget/hike_detail.dart';
import 'package:HikeTracker/pages/hiking/widget/reference_points.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Hiking extends StatefulWidget {
  const Hiking({
    required this.client,
    required this.user,
    required this.onHikeStart,
    super.key,
  });

  final RestClient client;
  final User user;
  final Function onHikeStart;

  @override
  State<Hiking> createState() => _HikingState();
}

class _HikingState extends State<Hiking> {
  late Future future;

  @override
  void initState() {
    future = widget.client.get(api: 'getOnGoingHike');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentPath: HIKING,
      currentUser: widget.user,
      onThemeChanged: () => {},
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final data = jsonDecode(snapshot.data!.body);
            return TwoColumnsLayout(
              leftChild: RefPointTable(
                client: widget.client,
                hikeSchedule: data['hike_schedule_id'],
                hikeID: data['hike_ID'],
              ),
              rightChild: FutureBuilder(
                future: widget.client.get(
                  api: 'hikesdetails/${data['hike_ID']}',
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final hike = Hike.fromJson(snapshot.data!.body);

                    return Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Details(
                          hike: hike,
                          isMine: widget.user.ID == hike.userId,
                          client: widget.client,
                          user: widget.user,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Expanded(
                          child: Center(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                await widget.client.put(
                                  api: 'updateSchedule',
                                  body: {
                                    'end_time': DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now()),
                                    'ID': data['hike_schedule_id'],
                                  },
                                );
                                widget.onHikeStart();
                              },
                              icon: const Icon(Icons.flag_outlined),
                              label: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Complete hike',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
