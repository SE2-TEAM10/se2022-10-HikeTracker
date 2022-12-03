// ignore_for_file: file_names

import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';

class HikeMap {
  HikeMap({
    required this.content,
    required this.gpx,
    required this.startLocation,
    required this.endLocation,
    required this.totalLength,
    required this.totalAscent,
    required this.track,
  });

  factory HikeMap.fromStringGPX({
    required String stringGpx,
  }) {
    final gpx = GpxReader().fromString(stringGpx);

    final slData = gpx.wpts[0];
    final startLocation = HikeLocation.fromWaypoint(slData);
    final elData = gpx.wpts[1];
    final endLocation = HikeLocation.fromWaypoint(elData);
    final trkData = gpx.trks.first.trksegs.first.trkpts;

    return HikeMap(
      content: stringGpx,
      gpx: gpx,
      startLocation: startLocation,
      endLocation: endLocation,
      totalLength: 0,
      totalAscent: 0,
      track: List<HikeTrackPoint>.from(
        trkData.map(
          (e) => HikeTrackPoint.fromWaypoint(e),
        ),
      ),
    );
  }

  final String content;
  final Gpx gpx;
  final HikeLocation startLocation;
  final HikeLocation endLocation;
  final double totalLength;
  final double totalAscent;
  final List<HikeTrackPoint> track;

  LatLng getTrackCenter() => LatLng(
        (startLocation.coordinates.latitude +
                endLocation.coordinates.latitude) /
            2,
        (startLocation.coordinates.longitude +
                endLocation.coordinates.longitude) /
            2,
      );

  HikeTrackPoint? getNearestTrackPoint(LatLng current) {
    var nearest;
    var min = 1000.0;
    track.forEach((p) {
      if (p.coordinates.distanceFrom(current) < min) {
        nearest = p;
        min = p.coordinates.distanceFrom(current);
      }
    });
    return nearest;
  }
}

class HikeLocation {
  HikeLocation({
    required this.name,
    required this.city,
    required this.province,
    required this.coordinates,
  });

  factory HikeLocation.fromWaypoint(Wpt waypoint) {
    final parts = waypoint.desc!.split(',');
    return HikeLocation(
      name: parts[0].split('=')[1].trim(),
      city: parts[1].trim(),
      province: parts[2].trim(),
      coordinates: LatLng(waypoint.lat!, waypoint.lon!),
    );
  }

  final String name;
  final String city;
  final String province;
  final LatLng coordinates;
}

class HikeTrackPoint {
  HikeTrackPoint({
    required this.coordinates,
    required this.elevation,
  });

  static HikeTrackPoint fromWaypoint(Wpt waypoint) {
    return HikeTrackPoint(
      coordinates: LatLng(waypoint.lat!, waypoint.lon!),
      elevation: waypoint.ele!,
    );
  }

  final LatLng coordinates;
  final double elevation;
}

extension LatLngExt on LatLng {
  double distanceFrom(LatLng b) => const Distance(roundResult: false).as(
        LengthUnit.Meter,
        this,
        b,
      );
}
