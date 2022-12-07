import 'package:HikeTracker/common/city_input_field/city_input_field.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/pages/add_hut/models/new_hut.dart';
import 'package:HikeTracker/pages/add_hut/widget/add_hut_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';

import '../../common/message.dart';

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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TwoColumnsLayout(
            leftChild: CityInputField(client: widget.client),
            rightChild: AddHutForm(
              onSubmit: (
                newHut,
              ) =>
                  onSubmit(
                newHut: newHut,
              ),
              isSmall: context.breakpoint <= LayoutBreakpoint.xs,
            ),
          );
  }

  Future<void> onSubmit({
    required NewHut newHut,
  }) async {
    /*
    if (mapData == null) {
      Message(
        context: context,
        message: 'Select a GPX file.',
      ).show();
      return;
    }
    newHike = newHike.copyWith(gpx: mapData!.content);
    */
    var a = newHut.toMap();
    final res = await widget.client.post(
      body: newHut.toMap(),
      api: 'addHut',
    );

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Hike added successfully.',
      ).show();
      GoRouter.of(context).pop();
    } else if (res.statusCode == 422) {
      Message(
        context: context,
        message: 'Gpx file error.',
        messageType: MessageType.Error,
      ).show();
    } else {
      Message(
        context: context,
        message: 'Internal error.',
        messageType: MessageType.Error,
      ).show();
    }
  }
}
