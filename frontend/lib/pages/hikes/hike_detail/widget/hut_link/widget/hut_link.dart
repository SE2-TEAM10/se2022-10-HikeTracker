import 'package:HikeTracker/pages/huts/models/hut.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HutLinkForm extends StatefulWidget {
  const HutLinkForm({
    required this.onSubmit,
    required this.client,
    this.latitude,
    this.longitude,
    this.disabled = true,
    super.key,
  });

  final Function(int?) onSubmit;
  final RestClient client;
  final double? latitude;
  final double? longitude;
  final bool disabled;

  @override
  State<HutLinkForm> createState() => _HutLinkForm();
}

class _HutLinkForm extends State<HutLinkForm> {
  String? hut;
  int? hutID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: context.isMobile ? 16 : 128,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.disabled == true
              ? const Text(
                  'Select a hut to link to the hike:',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  selectionColor: CupertinoColors.systemRed,
                )
              : FutureBuilder(
                  future: widget.client.get(
                    api: 'pointToLinkHut',
                    queryParameters: {
                      'latitude': widget.latitude,
                      'longitude': widget.longitude,
                      'ref': 'hut',
                    },
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final huts = Huts.fromJson(snapshot.data!.body);
                      if (huts.isEmpty()) {
                        return const Text('No huts in the area');
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('select the hut'),
                          const SizedBox(
                            height: 16,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: DropdownButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                underline: const SizedBox(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                value: hut,
                                onChanged: (String? value) {
                                  if (widget.disabled == true) {
                                    return null;
                                  }
                                  setState(() {
                                    hut = value!;
                                  });
                                },
                                items: huts.results!
                                    .map(
                                      (Hut h) => DropdownMenuItem<String>(
                                        value: h.name,
                                        child: Text(h.name),
                                        onTap: () => setState(() {
                                          hutID = h.id;
                                        }),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => widget.onSubmit(
                                  hutID,
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
                      );
                    }
                    return Container();
                  },
                )
        ],
      ),
    );
  }
}
