import 'package:flutter/material.dart';

class AutocompleteItem {
  AutocompleteItem({
    required this.value,
    required this.label,
  });

  final dynamic value;
  final String label;

  @override
  String toString() {
    return label;
  }
}

class AutocompleteInputField extends StatelessWidget {
  const AutocompleteInputField({
    required this.label,
    this.items,
    this.onSelect,
    this.disabled = false,
    super.key,
  });

  final String label;
  final List<AutocompleteItem>? items;
  final void Function(AutocompleteItem)? onSelect;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: disabled
                ? Theme.of(context).colorScheme.outline.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: disabled
                  ? Theme.of(context).colorScheme.outline.withOpacity(0.3)
                  : Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: (items == null || disabled)
                ? const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    enabled: false,
                  )
                : Autocomplete<AutocompleteItem>(
                    optionsBuilder: (TextEditingValue input) {
                      if (input.text == '' || items == null) {
                        return const Iterable<AutocompleteItem>.empty();
                      }

                      return items!.where(
                        (e) => e
                            .toString()
                            .toLowerCase()
                            .contains(input.text.toLowerCase()),
                      );
                    },
                    onSelected: (AutocompleteItem selection) =>
                        onSelect?.call(selection),
                  ),
          ),
        ),
      ],
    );
  }
}
