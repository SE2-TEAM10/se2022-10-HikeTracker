import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/pages/add_reference_point/models/new_reference.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddReferencePointForm extends StatefulWidget {
  const AddReferencePointForm({
    required this.onSubmit,
    super.key,
  });

  final Function(NewReferencePoint) onSubmit;

  @override
  State<AddReferencePointForm> createState() => _AddReferencePointFormState();
}

class _AddReferencePointFormState extends State<AddReferencePointForm> {
  late NewReferencePoint referencePoint;

  String? gpxContent;

  @override
  void initState() {
    referencePoint = NewReferencePoint();
    super.initState();
  }

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
            onChange: (value) => setState(
                  () => referencePoint = referencePoint.copyWith(name: value),
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
            onChange: (value) => setState(
                  () => referencePoint = referencePoint.copyWith(type: value),
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
}
