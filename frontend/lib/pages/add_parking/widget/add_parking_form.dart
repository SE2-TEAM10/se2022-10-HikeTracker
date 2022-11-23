import 'package:flutter/material.dart';

import '../models/parking_controller.dart';

class AddParkingForm extends StatefulWidget {
  const AddParkingForm({
    required this.onSubmit,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(Parking) onSubmit;

  @override
  State<AddParkingForm> createState() => _AddParkingFormState();
}

class _AddParkingFormState extends State<AddParkingForm> {
  late Parking parking = Parking();

  String? gpxContent;

  @override
  void initState() {
    parking.name = TextEditingController(text: 'prova');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: widget.isSmall ? 16 : 128,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'Add Parking',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Add your favourite parking',
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
