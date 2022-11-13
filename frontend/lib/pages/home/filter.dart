import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Filter {
  Filter();

  String? startAsc;
  String? endAsc;
  String? difficulty = 'ALL';
  String? startLen;
  String? endLen;
  String? city;
  String? province;
  static List<String> list = <String>['ALL', 'PH', 'H', 'T'];

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> query = {
      if (startAsc?.isNotEmpty ?? false) 'start_asc': "$startAsc",
      if (endAsc?.isNotEmpty ?? false) 'end_asc': "$endAsc",
      if (startLen?.isNotEmpty ?? false) 'start_len': "$startLen",
      if (endLen?.isNotEmpty ?? false) 'end_len': "$endLen",
      if ((difficulty?.isNotEmpty ?? false) && difficulty != 'ALL')
        'difficulty': "$difficulty",
      if (city?.isNotEmpty ?? false) 'city': "$city",
      if (province?.isNotEmpty ?? false) 'province': "$province",
    };
    return query;
  }
}

class FilterTab extends StatefulWidget {
  const FilterTab({
    super.key,
    required this.filterHikes,
  });

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
    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(children: [
                  //AscentFormField
                  Row(
                    children: <Widget>[
                      const Text('Ascent: '),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            onChanged: (value) =>
                                setState(() => filter.startAsc = value),
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
                                setState(() => filter.endAsc = value),
                          ))
                    ],
                  ),

                  //LengthFormField
                  Row(
                    children: <Widget>[
                      const Text('Length: '),
                      SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            onChanged: (value) =>
                                setState(() => filter.startLen = value),
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
                                setState(() => filter.endLen = value),
                          ))
                    ],
                  ),

                  Row(
                    children: [
                      const Text('Difficulty: '),
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
                    children: [
                      const Text('City: '),
                      SizedBox(
                          width: 100,
                          child: TextField(
                            onChanged: (value) =>
                                setState(() => filter.city = value),
                          )),
                    ],
                  ),

                  Row(
                    children: [
                      const Text('Province: '),
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
                    margin: const EdgeInsets.all(25),
                    child: ElevatedButton(
                      child: const Text(
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
      ),
    );
  }
}
