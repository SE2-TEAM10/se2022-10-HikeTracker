import 'package:HikeTracker/pages/add_hike/models/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddHikeForm extends StatefulWidget {
  const AddHikeForm({
    required this.onSubmit,
    this.isSmall = false,
    super.key,
  });

  final bool isSmall;
  final Function(String, String, String, String, String, Location, Location)
      onSubmit;

  @override
  State<AddHikeForm> createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm> {
  late TextEditingController nameController;
  late TextEditingController lengthController;
  late TimeOfDay time;
  late String difficulty;
  late TextEditingController descriptionController;
  final List<String> difficulties = <String>['T', 'PH', 'H'];
  late Location start = Location();
  late Location end = Location();

  @override
  void initState() {
    nameController = TextEditingController(text: 'Prova');
    lengthController = TextEditingController(text: '5');
    time = const TimeOfDay(hour: 7, minute: 15);
    difficulty = 'T';
    descriptionController = TextEditingController(text: 'A cool hike');
    start.city = TextEditingController(text: 'Sup');
    start.name = TextEditingController(text: 'Prova start');
    start.province = TextEditingController(text: 'Lecce');
    end.city = TextEditingController(text: 'Sup');
    end.name = TextEditingController(text: 'Prova end');
    end.province = TextEditingController(text: 'Lecce');
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
          PrimaryTextField(
            text: 'Name',
            controller: nameController,
          ),
          const SizedBox(
            height: 32,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Length',
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
              const Text(
                'Expected time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
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
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Column(
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
                    value: difficulty,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        difficulty = value!;
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
                    SecondaryTextField(
                      text: 'Name',
                      controller: start.name,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SecondaryTextField(
                      text: 'City',
                      controller: start.city,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SecondaryTextField(
                      text: 'Province',
                      controller: start.province,
                    )
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
                    SecondaryTextField(
                      text: 'Name',
                      controller: end.name,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SecondaryTextField(
                      text: 'City',
                      controller: end.city,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SecondaryTextField(
                      text: 'Province',
                      controller: end.province,
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          PrimaryTextField(
            text: 'Description',
            controller: descriptionController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => widget.onSubmit(
                  nameController.text,
                  lengthController.text,
                  '${time.hour}:${time.minute}',
                  difficulty,
                  descriptionController.text,
                  start,
                  end,
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
}

class PrimaryTextField extends StatelessWidget {
  PrimaryTextField({
    required this.text,
    required this.controller,
    super.key,
  });
  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
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
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SecondaryTextField extends StatelessWidget {
  SecondaryTextField({
    required this.text,
    required this.controller,
    super.key,
  });
  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DecoratedBox(
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
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
