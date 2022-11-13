import 'package:flutter/material.dart';
import 'package:frontend/pages/home/filter.dart';
import 'package:frontend/rest_client.dart';

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
          return ListView(
            children: [
              DataTable(
                dividerThickness: 2,
                dataRowHeight: 60,
                showBottomBorder: true,
                headingTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                columns: const [
                  'ID',
                  'Name',
                  'Length',
                  'Expected time',
                  'Ascent',
                  'Difficulty',
                  'Start point',
                  'End point'
                ]
                    .map(
                      (e) => DataColumn(
                        label: Text(
                          e,
                        ),
                      ),
                    )
                    .toList(),
                rows: hikes.results!
                    .map(
                      (p) => DataRow(
                        cells: [
                          DataCell(Text('${p.id}')),
                          DataCell(Text(p.name)),
                          DataCell(Text('${p.length}')),
                          DataCell(Text(p.expectedTime)),
                          DataCell(Text('${p.ascent}')),
                          DataCell(Text(p.difficulty)),
                          DataCell(Text(p.startPoint)),
                          DataCell(Text(p.endPoint)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
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
