import 'dart:convert';

import 'package:HikeTracker/models/user.dart';
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
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final data = jsonDecode(snapshot.data!.body);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You are currently hiking on: ${data['name']}'),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton.icon(
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
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
