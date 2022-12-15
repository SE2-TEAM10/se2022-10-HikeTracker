import 'dart:convert';

import 'package:HikeTracker/common/input_field.dart';
import 'package:HikeTracker/pages/add_hike/models/new_hike.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddHikeForm extends StatefulWidget {
  const AddHikeForm({
    required this.onSubmit,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(NewHike) onSubmit;

  @override
  State<AddHikeForm> createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm> {
  final List<String> difficulties = ['T', 'PH', 'H'];
  late NewHike hike;
  String? imageName;

  @override
  void initState() {
    hike = NewHike(
      hh: '00',
      mm: '00',
      startp: NewLocation(),
      endp: NewLocation(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: widget.isSmall ? 16 : 128,
        ),
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
          const SizedBox(
            height: 32,
          ),
          InputField(
            label: 'Name',
            onChange: (value) => setState(
              () => hike = hike.copyWith(name: value),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: InputField(
                  label: 'Hours:',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChange: (value) => setState(
                    () => hike = hike.copyWith(hh: value),
                  ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: InputField(
                  label: 'Minutes:',
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChange: (value) => setState(
                    () => hike = hike.copyWith(mm: value),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Difficulty',
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
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButton(
                          value: hike.difficulty,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          underline: const SizedBox(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              hike = hike.copyWith(difficulty: value);
                            });
                          },
                          items: difficulties
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cover image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextButton.icon(
                      onPressed: () => _selectImage(),
                      icon: const Icon(Icons.image),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          hike.imageBase64 != null && imageName != null
                              ? imageName!
                              : 'Select here',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start point',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'Name',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          startp: hike.startp?.copyWith(name: value),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'City',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          startp: hike.startp?.copyWith(city: value),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'Province',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          startp: hike.startp?.copyWith(province: value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End point',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'Name',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          endp: hike.endp?.copyWith(name: value),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'City',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          endp: hike.endp?.copyWith(city: value),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InputField(
                      label: 'Province',
                      onChange: (value) => setState(
                        () => hike = hike.copyWith(
                          endp: hike.endp?.copyWith(province: value),
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
          InputField(
            label: 'Description',
            onChange: (value) => setState(
              () => hike = hike.copyWith(
                description: value,
              ),
            ),
            multiline: true,
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => widget.onSubmit(
                  hike,
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
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final platformFile = result.files.single;
      final uploadfile = platformFile.bytes!;
      final base64String = base64Encode(uploadfile);
      setState(() {
        imageName = platformFile.name;
        hike = hike.copyWith(
          imageBase64: base64String,
        );
      });
    }
  }
}
