import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/pages/add_parking/models/new_parking.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddParkingForm extends StatefulWidget {
  const AddParkingForm({
    required this.onSubmit,
    super.key,
  });

  final Function(NewParking) onSubmit;

  @override
  State<AddParkingForm> createState() => _AddParkingFormState();
}

class _AddParkingFormState extends State<AddParkingForm> {
  late NewParking parking;

  String? gpxContent;

  @override
  void initState() {
    parking = NewParking();
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
            'Add parking lot',
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
              () => parking = parking.copyWith(name: value),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          InputField(
            label: 'Capacity',
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChange: (value) => setState(
              () => parking = parking.copyWith(capacity: value),
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
                  parking,
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
