import 'package:HikeTracker/pages/add_hut/widget/add_hut_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:layout/layout.dart';

import 'models/hut_controller.dart';

class AddHut extends StatefulWidget {
  const AddHut({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddHut> createState() => _AddHutState();
}

class _AddHutState extends State<AddHut> {
  bool isLoading = false;
  String? gpxContent;
  Gpx? gpx;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Row(
            children: [
              Container(),
              AddHutForm(
                onSubmit: (hut) => onSubmit(
                  hut: hut,
                ),
                isSmall: context.breakpoint <= LayoutBreakpoint.xs,
              ),
            ],
          );
  }

  Future<void> onSubmit({required Hut hut}) async {
    final res = await widget.client.post(
      api: 'hike',
      body: {
        'hut': {
          'name': hut.name?.text,
        }
      },
    );

    if (res.body == '"Incorrect"') {
      // TODO
    } else {
      // pop
    }
  }
}
