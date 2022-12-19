import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Details extends StatelessWidget {
  const Details({
    required this.hike,
    super.key,
  });

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: context.isMobile ? 16 : 128,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hike.name,
                  style: TextStyle(
                    fontSize: context.isMobile ? 18 : 32,
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
                  padding: EdgeInsets.all(context.isMobile ? 0 : 8.0),
                  child: Text(
                    hike.formatDifficulty(),
                    style: TextStyle(
                      fontSize: context.isMobile ? 14 : 20,
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
                  fontSize: context.isMobile ? 12 : 16,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Expanded(
                child: Text(
                  '${hike.length} Km',
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Duration: ',
                style: TextStyle(
                  fontSize: context.isMobile ? 12 : 16,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Expanded(
                child: Text(
                  hike.formatTime(),
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Ascent: ',
                style: TextStyle(
                  fontSize: context.isMobile ? 12 : 16,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Expanded(
                child: Text(
                  '${hike.ascent} m',
                  style: TextStyle(
                    fontSize: context.isMobile ? 12 : 16,
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
          Row(
            children: [
              if (hike.locations.isNotEmpty) hike.locations.first,
              Expanded(
                child: Icon(
                  Icons.arrow_right_alt_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  size: 52,
                ),
              ),
              if (hike.locations.length > 1) hike.locations[1]
            ]
                .asMap()
                .map(
                  (i, e) => MapEntry<int, Widget>(
                    i,
                    e is Location
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  i == 0 ? 'From:' : 'To:',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryContainer,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.name,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                      Text(
                                        '${e.city} (${e.province})',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : e is Widget
                            ? e
                            : Container(),
                  ),
                )
                .values
                .toList(),
          ),
          const SizedBox(
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
          const SizedBox(
            height: 32,
          ),
          Text(
            hike.description,
            style: TextStyle(
              fontSize: context.isMobile ? 14 : 18,
            ),
          ),
        ],
      ),
    );
  }
}
