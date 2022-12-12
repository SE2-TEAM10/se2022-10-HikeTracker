// ignore_for_file: file_names

import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';

//This class has the purpose of storing informations coming from a gpx file

class MapData {
  MapData({
    required this.content,
    required this.gpx,
    required this.track,
    required this.totalLength,
    required this.totalAscent,
    this.startLocation,
    this.endLocation,
  });

  factory MapData.fromStringGPX({
    required String stringGpx,
  }) {
    final gpx = GpxReader().fromString(stringGpx);

    return MapData(
      content: stringGpx,
      gpx: gpx,
      startLocation: gpx.wpts.isNotEmpty
          ? MapLocation.fromWaypoint(
              gpx.wpts.first,
            )
          : null,
      endLocation: gpx.wpts.isNotEmpty
          ? MapLocation.fromWaypoint(
              gpx.wpts.elementAt(1),
            )
          : null,
      totalLength: 0,
      totalAscent: 0,
      track: List<MapTrackPoint>.from(
        gpx.trks.first.trksegs.first.trkpts.map(
          (e) => MapTrackPoint.fromWaypoint(e),
        ),
      ),
    );
  }

  final String content;
  final Gpx gpx;
  final List<MapTrackPoint> track;
  final double totalLength;
  final double totalAscent;
  final MapLocation? startLocation;
  final MapLocation? endLocation;

  LatLng getTrackCenter() => track
      .elementAt(
        (track.length / 2).floor(),
      )
      .coordinates;

  MapTrackPoint? getNearestTrackPoint(LatLng current) {
    var nearest;
    var min = double.infinity;
    track.forEach((p) {
      if (p.coordinates.distanceFrom(current) < min) {
        nearest = p;
        min = p.coordinates.distanceFrom(current);
      }
    });
    return nearest;
  }
}

class MapLocation {
  MapLocation({
    required this.name,
    required this.city,
    required this.province,
    required this.coordinates,
  });

  factory MapLocation.fromWaypoint(Wpt waypoint) {
    final parts = waypoint.desc!.split(',');
    return MapLocation(
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

class MapTrackPoint {
  MapTrackPoint({
    required this.coordinates,
    required this.elevation,
  });

  static MapTrackPoint fromWaypoint(Wpt waypoint) {
    return MapTrackPoint(
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
