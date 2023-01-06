import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/common/time_field.dart';
import 'package:HikeTracker/pages/add_hut/models/new_hut.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddHutForm extends StatefulWidget {
  const AddHutForm({
    required this.onSubmit,
    super.key,
  });

  final Function(NewHut) onSubmit;

  @override
  State<AddHutForm> createState() => _AddHutFormState();
}

class _AddHutFormState extends State<AddHutForm> {
  late NewHut hut;

  String? gpxContent;

  @override
  void initState() {
    hut = NewHut(
      hhOp: TimeOfDay.now().hour,
      mmOp: TimeOfDay.now().minute,
      hhEd: TimeOfDay.now().hour,
      mmEd: TimeOfDay.now().minute,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: context.isMobile ? 16 : 128,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add hut',
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
            const SizedBox(
              height: 32,
            ),
            InputField(
              label: 'Name',
              onChange: (value) => setState(
                () => hut = hut.copyWith(name: value),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: TimeField(
                    label: 'Opening time',
                    onChange: (newTime) => {
                      setState(() {
                        hut = hut.copyWith(hhOp: newTime.hour);
                        hut = hut.copyWith(mmOp: newTime.minute);
                      })
                    },
                    startingTime: '08:00',
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TimeField(
                    label: 'Closing time',
                    onChange: (newTime) => {
                      setState(() {
                        hut = hut.copyWith(hhEd: newTime.hour);
                        hut = hut.copyWith(mmEd: newTime.minute);
                      })
                    },
                    startingTime: '22:00',
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'Beds',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChange: (value) => setState(
                      () => hut = hut.copyWith(bednum: value),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InputField(
                    label: 'Altitude',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChange: (value) => setState(
                      () => hut = hut.copyWith(altitude: value),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            InputField(
              label: 'Phone',
              onChange: (value) => setState(
                () => hut = hut.copyWith(phone: value),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            InputField(
              label: 'Mail',
              onChange: (value) => setState(
                () => hut = hut.copyWith(mail: value),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            InputField(
              label: 'Website',
              onChange: (value) => setState(
                () => hut = hut.copyWith(website: value),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            InputField(
              label: 'Description',
              multiline: true,
              onChange: (value) => setState(
                () => hut = hut.copyWith(description: value),
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
                    hut,
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
      ),
    );
  }
}
