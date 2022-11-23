import 'package:flutter/material.dart';

import '../models/hut_controller.dart';

class AddHutForm extends StatefulWidget {
  const AddHutForm({
    required this.onSubmit,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(Hut) onSubmit;

  @override
  State<AddHutForm> createState() => _AddHutFormState();
}

class _AddHutFormState extends State<AddHutForm> {
  late Hut hut = Hut();

  String? gpxContent;

  @override
  void initState() {
    hut.name = TextEditingController(text: 'prova');
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
              'Add Hut',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Add your favourite hut',
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
