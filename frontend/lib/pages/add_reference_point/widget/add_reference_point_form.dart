import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/pages/add_reference_point/models/new_reference.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:HikeTracker/models/hike.dart';


import '../../add_hike/models/new_hike.dart';

class AddReferencePointForm extends StatefulWidget {
  const AddReferencePointForm({
    required this.onSubmit,
    required this.client,
    super.key,
  });

  final RestClient client;
  final Function(NewReferencePoint) onSubmit;

  @override
  State<AddReferencePointForm> createState() => _AddReferencePointFormState();
}

class _AddReferencePointFormState extends State<AddReferencePointForm> {
  late NewReferencePoint referencePoint;
  late NewHike hike;
  final List<String> difficulties = ['T', 'PH', 'H'];
  late Future<Response> future;
  String? gpxContent;

  @override
  void initState() {
    referencePoint = NewReferencePoint();
    hike = NewHike(
      hh: '00',
      mm: '00',
      startp: NewLocation(),
      endp: NewLocation(),
    );
    future = widget.client.get(
      api: 'hike',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: future,
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          final hikes = Hikes
              .fromJson(snapshot.data!.body)
              .results;

          final hike_name = hikes
              ?.map((e) => e.id)
              .toSet()
              .toList();

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: context.isMobile ? 16 : 128,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add reference point',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                InputField(
                  label: 'Name',
                  onChange: (value) =>
                      setState(
                            () =>
                        referencePoint = referencePoint.copyWith(name: value),
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                InputField(
                  label: 'Type',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChange: (value) =>
                      setState(
                            () =>
                        referencePoint = referencePoint.copyWith(type: value),
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            'Choose hike: ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .outline,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: DropdownButton(
                                value: referencePoint.hike_ID,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                underline: const SizedBox(),
                                style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    //hike = hike.copyWith(name: value);
                                    referencePoint = referencePoint.copyWith(hike_ID: value);
                                  });
                                },
                                items: hike_name
                                    ?.map(
                                      (int value) =>
                                      DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value.toString()),
                                      ),
                                )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () =>
                          widget.onSubmit(
                            referencePoint,
                          ),
                      icon: const Icon(Icons.check_rounded),
                      label: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        return Container();
      },
    );
  }
}