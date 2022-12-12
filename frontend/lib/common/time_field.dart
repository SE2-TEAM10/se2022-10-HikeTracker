import 'package:flutter/material.dart';

class TimeField extends StatefulWidget {
  const TimeField({
    required this.label,
    this.onChange,
    this.disabled = false,
    super.key,
    this.startingTime,
  });

  final void Function(TimeOfDay)? onChange;
  final String label;
  final bool disabled;
  final startingTime;

  @override
  State<TimeField> createState() => _TimeField();
}

class _TimeField extends State<TimeField> {
  late TimeOfDay time;

  @override
  void initState() {
    time = widget.startingTime != null
        ? TimeOfDay(
            hour: int.parse(widget.startingTime.split(':')[0]),
            minute: int.parse(widget.startingTime.split(':')[1]),
          )
        : TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16.0,
            color: widget.disabled
                ? Theme.of(context).colorScheme.outline.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            child: Text(time.format(context)),
            onPressed: () async {
              final newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (newTime != null) {
                setState(() {
                  time = newTime;
                });
                widget.onChange!(newTime);
              }
            },
          ),
        ),
      ],
    );
  }
}
