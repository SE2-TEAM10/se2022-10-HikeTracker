import 'dart:convert';

import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/models/map_data.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class Reference {
  const Reference({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  final int id;
  final String name;
  final LatLng coordinates;
}

class MapBanner extends StatefulWidget {
  const MapBanner({
    required this.client,
    this.onGpxLoaded,
    this.mapData,
    this.onTap,
    this.dense = false,
    this.selectFromTrack = false,
    this.mapBorders,
    this.isLoading = false,
    this.selectedCoordinates,
    this.refNearEndingPoint,
    this.refNearStartingPoint,
    this.selectableReferences,
    this.onSelectReference,
    this.otherReferences,
    super.key,
  });

  final RestClient client;
  final MapData? mapData;
  final Function(MapData?)? onGpxLoaded;
  final Function(LatLng)? onTap;
  final bool selectFromTrack;
  final bool dense;
  final MapBorders? mapBorders;
  final bool isLoading;
  final List<LatLng>? selectedCoordinates;
  final Reference? refNearStartingPoint;
  final Reference? refNearEndingPoint;
  final List<Reference>? selectableReferences;
  final Function(Reference)? onSelectReference;
  final List<Reference>? otherReferences;

  @override
  State<MapBanner> createState() => _MapBannerState();
}

class _MapBannerState extends State<MapBanner> {
  bool isLoading = false;
  late MapController controller;
  MapTrackPoint? nearestToMouse;
  LatLng? currentMouse;

  @override
  void initState() {
    controller = MapController();
    super.initState();
  }

  bool get loading {
    return isLoading || widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.dense ? EdgeInsets.zero : const EdgeInsets.all(16.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: DecorationImage(
            image: const AssetImage('assets/images/contour.png'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onPrimary,
              BlendMode.srcATop,
            ),
            opacity: 0.3,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              widget.dense ? 0 : 16.0,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            if (widget.mapData == null &&
                widget.mapBorders == null &&
                widget.onGpxLoaded != null &&
                !loading)
              TextButton(
                onPressed: _selectGpx,
                child: Icon(
                  Icons.upload,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
            if (widget.mapData == null && widget.mapBorders != null && !loading)
              Expanded(
                child: FlutterMap(
                  mapController: controller,
                  options: MapOptions(
                    center: widget.mapBorders?.getCenter(),
                    zoom: 15,
                    onTap: widget.onTap != null
                        ? (tapPosition, point) =>
                            widget.selectFromTrack && nearestToMouse != null
                                ? widget.onTap!(nearestToMouse!.coordinates)
                                : widget.onTap!(point)
                        : null,
                    onPointerHover: (event, point) => setState(() {
                      currentMouse = point;
                    }),
                  ),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          widget.dense ? 0 : 16.0,
                        ),
                      ),
                      child: TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                    ),
                    BorderPolyline(
                      mapBorders: widget.mapBorders,
                    ),
                    CurrentMouseMarkerLayer(
                      currentMouse: currentMouse,
                      selectFromTrack: widget.selectFromTrack,
                      nearestToMouse: nearestToMouse,
                      onTap: widget.onTap,
                    ),
                    SelectedCoordinatesMarkerLayer(
                      selectedCoordinates: widget.selectedCoordinates,
                    ),
                  ],
                ),
              ),
            if (widget.mapData != null && !loading)
              Expanded(
                child: FlutterMap(
                  mapController: controller,
                  options: MapOptions(
                    center: widget.mapData?.getTrackCenter(),
                    zoom: 15,
                    onTap: widget.onTap != null
                        ? (tapPosition, point) =>
                            widget.selectFromTrack && nearestToMouse != null
                                ? widget.onTap!(nearestToMouse!.coordinates)
                                : widget.onTap!(point)
                        : null,
                    onPointerHover: (event, point) => setState(() {
                      if (widget.selectFromTrack) {
                        nearestToMouse =
                            widget.mapData!.getNearestTrackPoint(point);
                      }
                      currentMouse = point;
                    }),
                  ),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          widget.dense ? 0 : 16.0,
                        ),
                      ),
                      child: TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                    ),
                    TrackPolyline(
                      track: widget.mapData!.track,
                      selectFromTrack: widget.selectFromTrack,
                      nearestToMouse: nearestToMouse,
                      currentMouse: currentMouse,
                    ),
                    BorderPolyline(
                      mapBorders: widget.mapBorders,
                    ),
                    CurrentMouseMarkerLayer(
                      currentMouse: currentMouse,
                      selectFromTrack: widget.selectFromTrack,
                      nearestToMouse: nearestToMouse,
                      onTap: widget.onTap,
                    ),
                    LocationsMarker(
                      startLocation: widget.mapData!.startLocation,
                      endLocation: widget.mapData!.endLocation,
                    ),
                    SelectedCoordinatesMarkerLayer(
                      selectedCoordinates: widget.selectedCoordinates,
                    ),
                    if (widget.refNearStartingPoint != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              widget.refNearStartingPoint!.coordinates.latitude,
                              widget
                                  .refNearStartingPoint!.coordinates.longitude,
                            ),
                            width: 64,
                            height: 64,
                            builder: (context) => Column(
                              children: [
                                Text(
                                  widget.refNearStartingPoint!.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (widget.refNearEndingPoint != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              widget.refNearEndingPoint!.coordinates.latitude,
                              widget.refNearEndingPoint!.coordinates.longitude,
                            ),
                            width: 64,
                            height: 64,
                            builder: (context) => Column(
                              children: [
                                Text(
                                  widget.refNearEndingPoint!.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withOpacity(0.4),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (widget.selectableReferences != null)
                      MarkerLayer(
                        markers: widget.selectableReferences!
                            .map(
                              (e) => Marker(
                                point: LatLng(
                                  e.coordinates.latitude,
                                  e.coordinates.longitude,
                                ),
                                width: 80,
                                height: 80,
                                builder: (context) => InkWell(
                                  onTap: () =>
                                      widget.onSelectReference?.call(e),
                                  child: SelectableMarkerContent(
                                    ref: e,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (widget.otherReferences != null)
                      MarkerLayer(
                        markers: widget.otherReferences!
                            .map(
                              (e) => Marker(
                                point: LatLng(
                                  e.coordinates.latitude,
                                  e.coordinates.longitude,
                                ),
                                width: 80,
                                height: 80,
                                builder: (context) => Column(
                                  children: [
                                    Text(
                                      e.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Center(
                                            child: Container(
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (widget.onGpxLoaded != null)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: TextButton(
                          onPressed: () => widget.onGpxLoaded!(null),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 24,
                          ),
                        ),
                      )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _selectGpx() async {
    setState(() {
      isLoading = true;
    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gpx'],
    );
    if (result != null) {
      final platformFile = result.files.single;
      final uploadfile = platformFile.bytes!;
      final gpxContent = utf8.decode(uploadfile);
      final mapData = MapData.fromStringGPX(stringGpx: gpxContent);
      widget.onGpxLoaded!(mapData);
    }
    setState(() {
      isLoading = false;
    });
  }
}

class BorderPolyline extends StatelessWidget {
  const BorderPolyline({
    required this.mapBorders,
    super.key,
  });

  final MapBorders? mapBorders;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        if (mapBorders != null)
          ...mapBorders!.borders
              .map(
                (b) => Polyline(
                  points: b,
                  color: Theme.of(context).colorScheme.error,
                  strokeWidth: 4,
                ),
              )
              .toList(),
      ],
    );
  }
}

class TrackPolyline extends StatelessWidget {
  const TrackPolyline({
    required this.track,
    required this.selectFromTrack,
    required this.nearestToMouse,
    required this.currentMouse,
    super.key,
  });

  final List<MapTrackPoint> track;
  final bool selectFromTrack;
  final MapTrackPoint? nearestToMouse;
  final LatLng? currentMouse;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: track
              .map(
                (e) => LatLng(
                  e.coordinates.latitude,
                  e.coordinates.longitude,
                ),
              )
              .toList(),
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 4,
        ),
        if (selectFromTrack && nearestToMouse != null)
          Polyline(
            points: [nearestToMouse!.coordinates, currentMouse!],
            color: Theme.of(context).colorScheme.onSurface,
            strokeWidth: 2,
            isDotted: true,
          ),
      ],
    );
  }
}

class LocationsMarker extends StatelessWidget {
  const LocationsMarker({
    this.startLocation,
    this.endLocation,
    super.key,
  });

  final MapLocation? startLocation;
  final MapLocation? endLocation;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        ...[startLocation, endLocation].where((e) => e != null).map(
              (e) => Marker(
                point: LatLng(
                  e!.coordinates.latitude,
                  e.coordinates.longitude,
                ),
                width: 24,
                height: 24,
                builder: (context) => Stack(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
      ],
    );
  }
}

class CurrentMouseMarkerLayer extends StatelessWidget {
  const CurrentMouseMarkerLayer({
    required this.currentMouse,
    required this.selectFromTrack,
    required this.nearestToMouse,
    required this.onTap,
    super.key,
  });

  final LatLng? currentMouse;
  final bool selectFromTrack;
  final MapTrackPoint? nearestToMouse;
  final Function(LatLng)? onTap;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        if (currentMouse != null && onTap != null) ...[
          Marker(
            height: 24,
            width: 24,
            anchorPos: AnchorPos.align(AnchorAlign.center),
            point:
                selectFromTrack ? nearestToMouse!.coordinates : currentMouse!,
            builder: (context) => DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            ),
          ),
          Marker(
            height: 16,
            width: 16,
            anchorPos: AnchorPos.align(AnchorAlign.center),
            point:
                selectFromTrack ? nearestToMouse!.coordinates : currentMouse!,
            builder: (context) => DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SelectedCoordinatesMarkerLayer extends StatelessWidget {
  const SelectedCoordinatesMarkerLayer({
    this.selectedCoordinates,
    super.key,
  });

  final List<LatLng>? selectedCoordinates;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        if (selectedCoordinates != null)
          ...selectedCoordinates!
              .map(
                (c) => [
                  Marker(
                    height: 24,
                    width: 24,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    point: c,
                    builder: (context) => DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                      ),
                    ),
                  ),
                  Marker(
                    height: 16,
                    width: 16,
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    point: c,
                    builder: (context) => DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              )
              .toList()
              .expand((e) => e)
              .toList()
      ],
    );
  }
}

class SelectableMarkerContent extends StatefulWidget {
  const SelectableMarkerContent({
    required this.ref,
    super.key,
  });

  final Reference ref;

  @override
  State<SelectableMarkerContent> createState() =>
      _SelectableMarkerContentState();
}

class _SelectableMarkerContentState extends State<SelectableMarkerContent> {
  late bool hover;

  @override
  void initState() {
    hover = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.ref.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        MouseRegion(
          onEnter: (event) => setState(() {
            hover = true;
          }),
          onExit: (event) => setState(() {
            hover = false;
          }),
          child: Stack(
            children: [
              const SizedBox(
                height: 32,
                width: 32,
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: hover ? 32 : 24,
                    width: hover ? 32 : 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: hover ? 24 : 16,
                    width: hover ? 24 : 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
