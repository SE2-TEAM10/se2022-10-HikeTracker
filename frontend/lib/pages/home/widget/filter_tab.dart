import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/home/models/filter.dart';

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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            16.0,
          ),
        ),
      ),
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
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
