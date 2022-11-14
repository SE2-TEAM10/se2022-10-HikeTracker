import 'package:flutter/material.dart';
import 'package:frontend/pages/home/filter.dart';
import 'package:frontend/rest_client.dart';
import 'package:layout/layout.dart';

import 'hike.dart';

class HikesTable extends StatefulWidget {
  const HikesTable({super.key, required this.filter, required this.client});

  final Filter filter;
  final RestClient client;

  @override
  State<StatefulWidget> createState() => _HikesTableState();
}

class _HikesTableState extends State<HikesTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.get(
        api: 'hike',
        filter: widget.filter,
      ),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final hikes = Hikes.fromJson(snapshot.data!.body);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: context.breakpoint < LayoutBreakpoint.sm
                  ? 1
                  : context.breakpoint < LayoutBreakpoint.md
                      ? 2
                      : context.breakpoint < LayoutBreakpoint.lg
                          ? 3
                          : 4,
            ),
            itemCount: hikes.results?.length ?? 0,
            itemBuilder: (context, index) {
              final h = hikes.results![index];
              return Card(
                color: Colors.white,
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            h.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            h.difficulty,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${h.length} Km'),
                          Text('${h.expectedTime} h'),
                          Text('${h.ascent} m'),
                        ],
                      ),
                      const Divider(),
                      Text('Start: ${h.startPoint}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(h.startLocation.city),
                          Text(h.startLocation.province),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lat: ${h.startLocation.latitude}'),
                          Text('Lon: ${h.startLocation.longitude}'),
                        ],
                      ),
                      const Divider(),
                      Text('Arrival: ${h.endPoint}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(h.endLocation.city),
                          Text(h.endLocation.province),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lat: ${h.endLocation.latitude}'),
                          Text('Lon: ${h.endLocation.longitude}'),
                        ],
                      ),
                      const Divider(),
                      Text(h.description),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
