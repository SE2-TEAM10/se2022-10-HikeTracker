import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.client,
    required this.user,
    required this.onLogged,
    super.key,
  });

  final RestClient client;
  final User user;
  final Function onLogged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile)
            const SizedBox(
              height: 80,
            ),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      image: DecorationImage(
                        image: const AssetImage('assets/images/contour.png'),
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onSecondaryContainer,
                          BlendMode.srcATop,
                        ),
                        opacity: 0.3,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          200.0,
                        ),
                        bottomLeft: Radius.circular(
                          16.0,
                        ),
                        bottomRight: Radius.circular(
                          16.0,
                        ),
                        topRight: Radius.circular(
                          16.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 360.0, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await client.delete(
                                api: 'sessions/current',
                              );
                              onLogged(null);
                            },
                            icon: const Icon(Icons.logout),
                            label: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 128,
                bottom: 0,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: 94,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          child: SvgPicture.asset(
                            'assets/images/avatar.svg',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          // Container(
          //   color: Colors.amber,
          //   height: 400,
          //   width: 300,
          //   child: const Center(
          //     child: Text('Preferences'),
          //   ),
          // )
        ],
      ),
    );
  }
}
