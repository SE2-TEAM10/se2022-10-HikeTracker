import 'package:flutter/material.dart';


class _DataTableExample extends StatefulWidget {
  const _DataTableExample({super.key});

  @override
  State<StatefulWidget> createState() => _DataTableExampleState();
}


  class _DataTableExampleState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Flutter DataTable Example'),
          ),
          body: ListView(children: <Widget>[
            Center(
                child: Text(
                  'List of hikes',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            DataTable(
            columns: [
            DataColumn(
                label: Text('ID',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Length',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Expected time',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Ascent',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Difficulty',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Start point',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('End point',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ], rows: [
            DataRow(cells: [
              DataCell(Text('1')),
              DataCell(Text('Monte Tivoli')),
              DataCell(Text('5')),
              DataCell(Text('02:00')),
              DataCell(Text('410')),
              DataCell(Text('T')),
              DataCell(Text('Crissolo')),
              DataCell(Text('Monte Tivoli')),
            ]),
            DataRow(cells: [
              DataCell(Text('2')),
              DataCell(Text('Laghi del Paione')),
              DataCell(Text('11')),
              DataCell(Text('04:15')),
              DataCell(Text('640')),
              DataCell(Text('H')),
              DataCell(Text('Rifugio San Bernardo')),
              DataCell(Text('Laghi del Paione')),
            ]),
            DataRow(cells: [
              DataCell(Text('3')),
              DataCell(Text('Rocciamelone')),
              DataCell(Text('9')),
              DataCell(Text('06:30')),
              DataCell(Text('1353')),
              DataCell(Text('PH')),
              DataCell(Text('Rifugio La Riposa')),
              DataCell(Text('Rocciamelone')),
            ]),
            DataRow(cells: [
              DataCell(Text('4')),
              DataCell(Text('Rifugio Bertorello')),
              DataCell(Text('5')),
              DataCell(Text('01:25')),
              DataCell(Text('205')),
              DataCell(Text('T')),
              DataCell(Text('San Lorenzo Paesana')),
              DataCell(Text('Rifugio Bertorello')),
            ]),
            DataRow(cells: [
              DataCell(Text('5')),
              DataCell(Text('Rifugio Re Magi')),
              DataCell(Text('11')),
              DataCell(Text('03:15')),
              DataCell(Text('345')),
              DataCell(Text('T')),
              DataCell(Text('Pian Del Colle')),
              DataCell(Text('Rifugio Re Magi')),
            ]),
            DataRow(cells: [
              DataCell(Text('6')),
              DataCell(Text('Monte Cristetto')),
              DataCell(Text('14')),
              DataCell(Text('06:45')),
              DataCell(Text('800')),
              DataCell(Text('H')),
              DataCell(Text('Talucco')),
              DataCell(Text('Monte Cristetto')),
            ]),
            DataRow(cells: [
              DataCell(Text('5')),
              DataCell(Text('Rifugio Re Magi')),
              DataCell(Text('11')),
              DataCell(Text('03:15')),
              DataCell(Text('345')),
              DataCell(Text('T')),
              DataCell(Text('Pian Del Colle')),
              DataCell(Text('Rifugio Re Magi')),
            ]),
            DataRow(cells: [
              DataCell(Text('7')),
              DataCell(Text('Lago Afframont')),
              DataCell(Text('6')),
              DataCell(Text('03:15')),
              DataCell(Text('566')),
              DataCell(Text('H')),
              DataCell(Text('Balme')),
              DataCell(Text('Lago Afframont')),
            ]),
            DataRow(cells: [
              DataCell(Text('8')),
              DataCell(Text('Monte Ferra')),
              DataCell(Text('13')),
              DataCell(Text('05:15')),
              DataCell(Text('1280')),
              DataCell(Text('PH')),
              DataCell(Text('Bellino')),
              DataCell(Text('Monte Ferra')),
            ]),
            DataRow(cells: [
              DataCell(Text('9')),
              DataCell(Text('Taou Blanc')),
              DataCell(Text('12')),
              DataCell(Text('05:45')),
              DataCell(Text('904')),
              DataCell(Text('PH')),
              DataCell(Text('Rifugio Savoia')),
              DataCell(Text('Monte Taou Blanc')),
            ]),
          ],
        ),
      ]),
    );
  }
}