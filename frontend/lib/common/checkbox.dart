import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    required this.checked,
    super.key,
  });

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        child: checked
            ? Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
            : Container(),
      ),
    );
  }
}
