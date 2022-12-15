import 'package:HikeTracker/models/hike.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:layout/layout.dart';

class Details extends StatelessWidget {
  const Details({
    required this.hike,
    super.key,
  });

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    // final location1 = hike.locations.first;
    // final location2 = hike.locations.elementAt(1);

    final isSmall = context.breakpoint < LayoutBreakpoint.md;

    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          padding: isSmall
              ? const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                )
              : const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 128,
                ),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    hike.name,
                    style: TextStyle(
                      fontSize: isSmall ? 18 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  backgroundColor: hike.difficultyColor(
                    context,
                  ),
                  label: Padding(
                    padding: EdgeInsets.all(isSmall ? 0 : 8.0),
                    child: Text(
                      hike.formatDifficulty(),
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 20,
                        color: hike.difficultyTextColor(
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distance: ',
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${hike.length} Km',
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Duration: ',
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    hike.formatTime(),
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Ascent: ',
                  style: TextStyle(
                    fontSize: isSmall ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${hike.ascent} m',
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 16,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 32,
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                image: DecorationImage(
                  image: NetworkImage(
                    '${dotenv.env['ASSETS_ENDPOINT']}${hike.coverUrl}',
                    scale: 0.5,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    16.0,
                  ),
                ),
              ),
            ),
            const Divider(
              height: 32,
            ),
            Text(
              hike.description,
              style: TextStyle(
                fontSize: isSmall ? 14 : 18,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            /*
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Starting point',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location1['name']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location1['city']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location1['province']}',
                        style: const TextStyle(
                          fontSize: 18.0,
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
                        'Destination',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location2['name']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location2['city']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${location2['province']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            */
          ],
        ),
      ],
    );
  }
}
