import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.label,
    this.controller,
    this.onChange,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.multiline = false,
    super.key,
  });

  final TextEditingController? controller;
  final void Function(String)? onChange;
  final String label;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              controller: controller,
              onChanged: onChange,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              obscureText: isPassword,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: multiline ? 3 : 1,
            ),
          ),
        ),
      ],
    );
  }
}
