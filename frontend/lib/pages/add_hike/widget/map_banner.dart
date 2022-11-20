import 'package:flutter/material.dart';

class MapBanner extends StatelessWidget {
  const MapBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                16.0,
              ),
            ),
          ),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
