import 'dart:convert';

import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';

class HikeDetail extends StatefulWidget {
  const HikeDetail({
    required this.client,
    required this.hikeID,
    this.user,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final User? user;

  @override
  State<HikeDetail> createState() => _HikeDetailState();
}

class _HikeDetailState extends State<HikeDetail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.get(
        api: 'hikesdetails/${widget.hikeID}',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        if (snapshot.hasData) {
          final hike = jsonDecode(snapshot.data!.body).first;
          final gpx = hike['gpx'];
          return Row(
            children: [
              if (widget.user != null)
                MapBanner(
                  gpx: GpxReader().fromString(gpx),
                  onGpxLoaded: (val, text) => {},
                ),
              Expanded(
                flex: 3,
                child: Details(
                  hike: hike,
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}

class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.hike,
  });

  final Map<String, dynamic> hike;

  @override
  Widget build(BuildContext context) {
    final location1 = hike['location'][0];
    final location2 = hike['location'][1];

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 128,
      ),
      children: [
        const Text(
          'Hike details',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Name: ${hike['name']}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Length: ${hike['length']} km',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Expected time: ${hike['expected_time']}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Ascent: ${hike['ascent']}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          'Difficulty: ${hike['difficulty']}',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          '${hike['description']}',
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Starting point',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location1['name']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location1['city']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location1['province']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destination',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location2['name']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location2['city']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${location2['province']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
