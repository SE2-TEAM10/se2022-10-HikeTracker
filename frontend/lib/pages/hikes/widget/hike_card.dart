import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HikeCard extends StatelessWidget {
  const HikeCard({
    required this.hike,
    required this.onTap,
    required this.user,
    super.key,
  });

  final Hike hike;
  final Function onTap;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            16.0,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              16.0,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // ignore: use_decorated_box
                      child: Container(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hike.name,
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                                fontWeight: FontWeight.bold,
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${hike.length} Km',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Duration: ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                hike.formatTime(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: 24,
                right: 24,
                child: Chip(
                  backgroundColor: hike.difficultyColor(
                    context,
                  ),
                  label: Text(
                    hike.formatDifficulty(),
                    style: TextStyle(
                      color: hike.difficultyTextColor(
                        context,
                      ),
                    ),
                  ),
                ),
              ),
              if (user?.ID == hike.userId)
                Positioned(
                  top: 24,
                  left: 24,
                  child: Chip(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    label: Text(
                      'Mine',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
