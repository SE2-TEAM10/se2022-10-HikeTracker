import 'dart:convert';

import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/parking.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class Details extends StatelessWidget {
  const Details({
    required this.hike,
    required this.client,
    this.isMine = false,
    super.key,
  });

  final Hike hike;
  final bool isMine;
  final RestClient client;

  Future<void> createSchedule() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final response = await http.post(
      Uri.parse('http://localhost:3001/api/addSchedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'start_time': formattedDate,
        'duration' : '1D',
        'hike_ID' : hike.id,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('OK');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              OutlinedButton.icon(
                onPressed: () {
                  createSchedule();
                },
                icon: const Icon(Icons.flag_outlined),
                label:  Padding(
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SelectHut(
                        client: client,
                        hikeID: hike.id,
                        start: true,
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
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SelectHut(
                        client: client,
                        hikeID: hike.id,
                        start: false,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}

class SelectParking extends StatelessWidget {
  const SelectParking({
    required this.client,
    required this.hikeID,
    required this.start,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final bool start;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: client.get(
        api: 'locationToLinkHutOrParking',
        queryParameters: {
          'hike_ID': hikeID,
          'start_end': 'start',
          'ref': 'p_lot',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final res = jsonDecode(snapshot.data!.body) as List<dynamic>;

          final parkingLots =
              res.map((e) => Parking.fromJson(jsonEncode(e))).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a parking lot to link to the ${start ? 'starting point' : 'ending point'}:',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 16,
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
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onChanged: (int? value) {
                      if (value == null) {
                        return;
                      }
                      client.post(
                        api: 'linkParking',
                        body: {
                          'hike_ID': hikeID,
                          'parking_ID': value,
                          'ref_type': 'point'
                        },
                      );
                    },
                    items: parkingLots
                        .map(
                          (Parking p) => DropdownMenuItem<int>(
                            value: p.id,
                            child: Text(p.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
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
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final bool start;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: client.get(
        api: 'locationToLinkHutOrParking',
        queryParameters: {
          'hike_ID': hikeID,
          'start_end': 'start',
          'ref': 'hut',
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final res = jsonDecode(snapshot.data!.body) as List<dynamic>;

          final parkingLots =
              res.map((e) => Parking.fromJson(jsonEncode(e))).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a hut to link to the ${start ? 'starting point' : 'ending point'}:',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 16,
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
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onChanged: (String? value) {},
                    items: parkingLots
                        .map(
                          (Parking p) => DropdownMenuItem<String>(
                            value: p.name,
                            child: Text(p.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
