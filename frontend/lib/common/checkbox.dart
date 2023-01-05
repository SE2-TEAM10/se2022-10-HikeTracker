import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    this.onChange,
    this.disabled = false,
    super.key,
    this.startingState,
  });

  final void Function()? onChange;
  final bool disabled;
  final startingState;

  @override
  State<CustomCheckbox> createState() => _CustomCheckbox();
}

class _CustomCheckbox extends State<CustomCheckbox> {
  late bool state;

  @override
  void initState() {
    state = widget.startingState ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Checkbox(
        value: state,
        onChanged: (value) {
          widget.onChange!();
          setState(() {
            state = true;
          });
        },
      ),
    );
  }
}
