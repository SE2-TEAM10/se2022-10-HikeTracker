import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpx/gpx.dart';

class AddHikeForm extends StatefulWidget {
  const AddHikeForm({
    required this.onSubmit,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(String, String) onSubmit;

  @override
  State<AddHikeForm> createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm> {
  late TextEditingController nameController;
  late TextEditingController lengthController;
  late TimeOfDay time;

  String? gpxContent;

  @override
  void initState() {
    nameController = TextEditingController(text: 'Prova');
    lengthController = TextEditingController(text: '5');
    time = const TimeOfDay(hour: 7, minute: 15);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Hike',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Add your favourite hike',
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Length',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: lengthController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expected time',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          child: Text('${time.hour}:${time.minute}'),
                          onPressed: () async {
                            final newTime = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (newTime != null) {
                              setState(() {
                                time = newTime;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPX file',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          child: const Text('Upload'),
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['gpx'],
                            );
                            if (result != null) {
                              final platformFile = result.files.single;
                              final uploadfile = platformFile.bytes!;
                              gpxContent = utf8.decode(uploadfile);
                              final xmlGpx =
                                  GpxReader().fromString(gpxContent!);

                              print(xmlGpx.creator);
                              print(xmlGpx.extensions);
                              print(xmlGpx.metadata);
                              print(xmlGpx.rtes);
                              print(xmlGpx.trks);
                              print(xmlGpx.wpts);
                            } else {
                              // User canceled the picker
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => widget.onSubmit(
                        nameController.text,
                        lengthController.text,
                      ),
                      icon: const Icon(Icons.login),
                      label: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
//