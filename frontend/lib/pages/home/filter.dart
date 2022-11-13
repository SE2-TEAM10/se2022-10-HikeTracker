import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Filter {
  Filter();

  String? start_asc;
  String? end_asc;
  String? difficulty = 'ALL';
  String? start_len;
  String? end_len;
  String? city;
  String? province;
  static List<String> list = <String>['ALL', 'PH', 'H', 'T'];

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> query = Map<String, dynamic>();
    if (start_asc != null) {
      query['start_asc'] = "$start_asc";
    }
    if (end_asc != null) {
      query['end_asc'] = "$end_asc";
    }
    if (start_len != null) {
      query['start_len'] = "$start_len";
    }
    if (end_len != null) {
      query['end_len'] = "$end_len";
    }
    if (difficulty != null && difficulty != 'ALL') {
      query['difficulty'] = "$difficulty";
    }
    if (city != null && city != '') {
      query['city'] = "$city";
    }
    if (province != null && province != '') {
      query['province'] = "$province";
    }
    return query;
  }
}

class FilterTab extends StatefulWidget {
  const FilterTab({super.key, required this.filterHikes});

  final Function filterHikes;
  @override
  State<StatefulWidget> createState() => _FilterTab();
}

class _FilterTab extends State<FilterTab> {
  final _formKey = GlobalKey<FormState>();
  Filter filter = Filter();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(children: [
                //AscentFormField
                Row(
                  children: <Widget>[
                    Text('Ascent: '),
                    SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          onChanged: (value) =>
                              setState(() => filter.start_asc = value),
                        )),
                    const Text("to "),
                    SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          onChanged: (value) =>
                              setState(() => filter.end_asc = value),
                        ))
                  ],
                ),

                //LengthFormField
                Row(
                  children: <Widget>[
                    Text('Length: '),
                    SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          onChanged: (value) =>
                              setState(() => filter.start_len = value),
                        )),
                    const Text("to"),
                    SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          onChanged: (value) =>
                              setState(() => filter.end_len = value),
                        ))
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('Difficulty: '),
                    SizedBox(
                        width: 50,
                        child: DropdownButton<String>(
                          value: filter.difficulty,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              filter.difficulty = value!;
                            });
                          },
                          items: Filter.list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('City: '),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          onChanged: (value) =>
                              setState(() => filter.city = value),
                        )),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('Province: '),
                    SizedBox(
                        width: 100,
                        child: TextField(
                          onChanged: (value) =>
                              setState(() => filter.province = value),
                        )),
                  ],
                ),

                //submit
                Container(
                  margin: EdgeInsets.all(25),
                  child: ElevatedButton(
                    child: Text(
                      'Filter',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      widget.filterHikes(filter);
                    },
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
