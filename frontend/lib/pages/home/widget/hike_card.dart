import 'package:flutter/material.dart';
import 'package:frontend/pages/home/models/hike.dart';

class HikeCard extends StatelessWidget {
  const HikeCard({
    Key? key,
    required this.hike,
  }) : super(key: key);

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              16.0,
            ),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hike.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  hike.difficulty,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${hike.length} Km'),
                Text('${hike.expectedTime} h'),
                Text('${hike.ascent} m'),
              ],
            ),
            const Divider(),
            Text('Start: ${hike.startPoint}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hike.startLocation.city),
                Text(hike.startLocation.province),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lat: ${hike.startLocation.latitude}'),
                Text('Lon: ${hike.startLocation.longitude}'),
              ],
            ),
            const Divider(),
            Text('Arrival: ${hike.endPoint}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hike.endLocation.city),
                Text(hike.endLocation.province),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lat: ${hike.endLocation.latitude}'),
                Text('Lon: ${hike.endLocation.longitude}'),
              ],
            ),
            const Divider(),
            Text(hike.description),
          ],
        ),
      ),
    );
  }
}
