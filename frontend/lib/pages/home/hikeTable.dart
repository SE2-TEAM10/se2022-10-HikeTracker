import 'package:flutter/material.dart';
import 'package:frontend/pages/home/filter.dart';
import 'package:frontend/rest_client.dart';
import 'package:http/http.dart';

import 'hike.dart';

class DataTableExample extends StatefulWidget {
  const DataTableExample(
      {super.key, required this.filter, required this.client});

  final Filter filter;
  final RestClient client;

  @override
  State<StatefulWidget> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.get(api: 'hike', filter: widget.filter),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final hikes = Hikes.fromJson(snapshot.data!.body);
          return SizedBox(
            width: 1500,
            height: 1000,
            child: ListView(children: <Widget>[
              Center(
                  child: Text(
                'List of hikes',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              DataTable(
                columns: [
                  DataColumn(
                      label: Text('ID',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Length',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Expected time',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ascent',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Difficulty',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Start point',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('End point',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
                rows: [
                  ...hikes.results!
                      .map((p) => DataRow(cells: [
                            DataCell(Text("${p.id}")),
                            DataCell(Text("${p.name}")),
                            DataCell(Text("${p.length}")),
                            DataCell(Text("${p.expected_time}")),
                            DataCell(Text("${p.ascent}")),
                            DataCell(Text("${p.difficulty}")),
                            DataCell(Text("${p.start_point}")),
                            DataCell(Text("${p.end_point}")),
                          ]))
                      .toList(),
                ],
              ),
            ]),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
