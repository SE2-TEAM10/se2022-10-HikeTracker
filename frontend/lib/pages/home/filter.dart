import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Filter {
  Filter();

  String? start_asc;
  String? end_asc;

  void toHeader() {
    String r = "";
    if (start_asc != null) {
      r = r;
    }
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
                    const Text("to"),
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

                //submit
                Container(
                  margin: const EdgeInsets.all(25),
                  child: ElevatedButton(
                    onPressed: widget.filterHikes(filter),
                    child: const Text(
                      'Filter',
                      style: TextStyle(fontSize: 20.0),
                    ),
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
      children: const [],
    );
  }
}
