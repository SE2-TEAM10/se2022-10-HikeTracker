import 'dart:convert';

import 'package:HikeTracker/models/HikeMap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:gpx/gpx.dart';
import 'package:latlong2/latlong.dart';

class MapBanner extends StatefulWidget {
  const MapBanner({
    required this.onGpxLoaded,
    this.hikeMap,
    this.onTap,
    this.dense = false,
    this.selectFromTrack = false,
    super.key,
  });

  final HikeMap? hikeMap;
  final Function(Gpx?, String?) onGpxLoaded;
  final Function(LatLng)? onTap;
  final bool selectFromTrack;
  final bool dense;

  @override
  State<MapBanner> createState() => _MapBannerState();
}

class _MapBannerState extends State<MapBanner> {
  bool isLoading = false;
  late MapController controller;
  HikeTrackPoint? nearestToMouse;
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
              if (widget.hikeMap == null && !isLoading)
                TextButton(
                  onPressed: _selectGpx,
                  child: Icon(
                    Icons.upload,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                ),
              if (widget.hikeMap != null && !isLoading)
                Expanded(
                  child: FlutterMap(
                    mapController: controller,
                    options: MapOptions(
                      center: widget.hikeMap!.getTrackCenter(),
                      zoom: 15,
                      onTap: widget.onTap != null
                          ? (tapPosition, point) =>
                              widget.selectFromTrack && nearestToMouse != null
                                  ? widget.onTap!(nearestToMouse!.coordinates)
                                  : widget.onTap!(point)
                          : null,
                      onPointerHover: widget.selectFromTrack
                          ? (event, point) => setState(() {
                                nearestToMouse =
                                    widget.hikeMap!.getNearestTrackPoint(point);
                                currentMouse = point;
                              })
                          : null,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: widget.hikeMap!.track
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
                        widget.hikeMap!.startLocation,
                        widget.hikeMap!.endLocation
                      ].map(
                        (e) => MarkerLayer(
                          markers: [
                            if (widget.selectFromTrack &&
                                nearestToMouse != null) ...[
                              Marker(
                                height: 24,
                                width: 24,
                                anchorPos: AnchorPos.align(AnchorAlign.center),
                                point: nearestToMouse!.coordinates,
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
                                point: nearestToMouse!.coordinates,
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
                      Positioned(
                        top: 16,
                        right: 16,
                        child: TextButton(
                          onPressed: () => widget.onGpxLoaded(null, null),
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
      final xmlGpx = GpxReader().fromString(gpxContent);
      widget.onGpxLoaded(xmlGpx, gpxContent);
    }
    setState(() {
      isLoading = false;
    });
  }
}
