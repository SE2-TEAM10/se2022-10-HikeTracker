import 'dart:convert';

import 'package:HikeTracker/models/map_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapBanner extends StatefulWidget {
  const MapBanner({
    this.onGpxLoaded,
    this.mapData,
    this.onTap,
    this.dense = false,
    this.selectFromTrack = false,
    super.key,
  });

  final MapData? mapData;
  final Function(MapData?)? onGpxLoaded;
  final Function(LatLng)? onTap;
  final bool selectFromTrack;
  final bool dense;

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
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
              if (isLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              if (widget.mapData == null &&
                  widget.onGpxLoaded != null &&
                  !isLoading)
                TextButton(
                  onPressed: _selectGpx,
                  child: Icon(
                    Icons.upload,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
              if (widget.mapData != null && !isLoading)
                Expanded(
                  child: FlutterMap(
                    mapController: controller,
                    options: MapOptions(
                      center: widget.mapData!.getTrackCenter(),
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
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: widget.mapData!.track
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
                          if (widget.selectFromTrack && nearestToMouse != null)
                            Polyline(
                              points: [
                                nearestToMouse!.coordinates,
                                currentMouse!
                              ],
                              color: Theme.of(context).colorScheme.onSurface,
                              strokeWidth: 2,
                              isDotted: true,
                            ),
                        ],
                      ),
                      ...[
                        widget.mapData!.startLocation,
                        widget.mapData!.endLocation
                      ].map(
                        (e) => MarkerLayer(
                          markers: [
                            if (currentMouse != null) ...[
                              Marker(
                                height: 24,
                                width: 24,
                                anchorPos: AnchorPos.align(AnchorAlign.center),
                                point: widget.selectFromTrack
                                    ? nearestToMouse!.coordinates
                                    : currentMouse!,
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
                                point: widget.selectFromTrack
                                    ? nearestToMouse!.coordinates
                                    : currentMouse!,
                                builder: (context) => DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ],
                            Marker(
                              point: LatLng(
                                e.coordinates.latitude,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
