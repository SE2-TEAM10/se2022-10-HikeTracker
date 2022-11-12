import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Filter {
  Filter();

  String? start_asc;
  String? end_asc;
  String? difficulty;
  String? start_len;
  String? end_len;
  String? start_time;
  String? end_time;
  String? latitude;
  String? longitude;
  String? city;
  String? province;

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
    if (end_time != null) {
      query['end_time'] = "$end_time";
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

class AscentFormField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}
