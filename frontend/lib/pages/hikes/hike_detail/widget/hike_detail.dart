import 'dart:convert';

import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/parking.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/router/utils.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Details extends StatelessWidget {
  const Details({
    required this.hike,
    required this.client,
    required this.user,
    this.onDisplayReferences,
    this.onHikeStart,
    this.isMine = false,
    this.gpx,
    super.key,
  });

  final Hike hike;
  final bool isMine;
  final User? user;
  final RestClient client;
  final Function? onHikeStart;
  final Function(List<Reference>, bool, bool)? onDisplayReferences;
  final String? gpx;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: context.isMobile ? 16 : 128,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    hike.name,
                    style: TextStyle(
                      fontSize: context.isMobile ? 18 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  backgroundColor: hike.difficultyColor(
                    context,
                  ),
                  label: Padding(
                    padding: EdgeInsets.all(context.isMobile ? 0 : 8.0),
                    child: Text(
                      hike.formatDifficulty(),
                      style: TextStyle(
                        fontSize: context.isMobile ? 14 : 20,
                        color: hike.difficultyTextColor(
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                if (user != null &&
                    user!.role == UserRole.Hiker &&
                    onHikeStart != null)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await client.post(
                        api: 'addSchedule',
                        body: {
                          'start_time': DateFormat('yyyy-MM-dd HH:mm')
                              .format(DateTime.now()),
                          'hike_ID': hike.id,
                        },
                      );
                      onHikeStart?.call();
                    },
                    icon: const Icon(Icons.flag_outlined),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Start hike',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distance: ',
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${hike.length} Km',
                    style: TextStyle(
                      fontSize: context.isMobile ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Duration: ',
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    hike.formatTime(),
                    style: TextStyle(
                      fontSize: context.isMobile ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Ascent: ',
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${hike.ascent} m',
                    style: TextStyle(
                      fontSize: context.isMobile ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 32,
            ),
            Row(
              children: [
                if (hike.locations.isNotEmpty) hike.locations.first,
                Expanded(
                  child: Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    size: 52,
                  ),
                ),
                if (hike.locations.length > 1) hike.locations[1]
              ]
                  .asMap()
                  .map(
                    (i, e) => MapEntry<int, Widget>(
                      i,
                      e is Location
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    i == 0 ? 'From:' : 'To:',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 0,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                        Text(
                                          '${e.city} (${e.province})',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : e is Widget
                              ? e
                              : Container(),
                    ),
                  )
                  .values
                  .toList(),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                image: DecorationImage(
                  image: NetworkImage(
                    '${dotenv.env['ASSETS_ENDPOINT']}${hike.coverUrl}',
                    scale: 0.5,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              hike.description,
              style: TextStyle(
                fontSize: context.isMobile ? 14 : 18,
              ),
            ),
            if (isMine) ...[
              const Divider(
                height: 32,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectParking(
                          client: client,
                          hikeID: hike.id,
                          start: true,
                          onTap: onDisplayReferences != null
                              ? onDisplayReferences!
                              : (___, __, _) => {},
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SelectHut(
                          client: client,
                          hikeID: hike.id,
                          start: true,
                          onTap: onDisplayReferences != null
                              ? onDisplayReferences!
                              : (___, __, _) => {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectParking(
                            client: client,
                            hikeID: hike.id,
                            start: false,
                            onTap: onDisplayReferences != null
                                ? onDisplayReferences!
                                : (___, __, _) => {},
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SelectHut(
                            client: client,
                            hikeID: hike.id,
                            start: false,
                            onTap: onDisplayReferences != null
                                ? onDisplayReferences!
                                : (___, __, _) => {},
                          ),
                        ]),
                  ),
                ],
              ),
              const Divider(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => {
                      GoRouter.of(context)
                          .push('$HIKES/${hike.id}/link/hut', extra: gpx)
                    },
                    icon: const Icon(Icons.add_home),
                    label: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Link Hut',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class SelectParking extends StatelessWidget {
  const SelectParking({
    required this.client,
    required this.hikeID,
    required this.start,
    required this.onTap,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final bool start;
  final Function(List<Reference>, bool, bool) onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: client.get(
        api: 'locationToLinkHutOrParking',
        queryParameters: {
          'hike_ID': hikeID,
          'start_end': start ? 'start' : 'end',
          'ref': 'p_lot',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final res = jsonDecode(snapshot.data!.body) as List<dynamic>;

          final parkingLots =
              res.map((e) => Parking.fromJson(jsonEncode(e))).toList();

          return TextButton(
            onPressed: () => onTap.call(
              parkingLots
                  .map(
                    (e) => Reference(
                      id: e.id,
                      name: e.name,
                      coordinates: e.coordinate,
                    ),
                  )
                  .toList(),
              start,
              true,
            ),
            child: Text(
              start
                  ? 'Select the starting parking lot'
                  : 'Select the ending parking lot',
            ),
          );
        }
        return Container();
      },
    );
  }
}

class SelectHut extends StatelessWidget {
  const SelectHut({
    required this.client,
    required this.hikeID,
    required this.start,
    required this.onTap,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final bool start;
  final Function(List<Reference>, bool, bool) onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: client.get(
        api: 'locationToLinkHutOrParking',
        queryParameters: {
          'hike_ID': hikeID,
          'start_end': start ? 'start' : 'end',
          'ref': 'hut',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final res = jsonDecode(snapshot.data!.body) as List<dynamic>;

          final parkingLots =
              res.map((e) => Parking.fromJson(jsonEncode(e))).toList();

          return TextButton(
            onPressed: () => onTap.call(
              parkingLots
                  .map(
                    (e) => Reference(
                      id: e.id,
                      name: e.name,
                      coordinates: e.coordinate,
                    ),
                  )
                  .toList(),
              start,
              false,
            ),
            child: Text(
              start ? 'Select the starting hut' : 'Select the ending hut',
            ),
          );
        }
        return Container();
      },
    );
  }
}
