import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  final LatLng posDepart;
  final LatLng posArrivee;

  Map({required this.posDepart, required this.posArrivee});

  List<LatLng> _generateBezierPoints(LatLng depart, LatLng arrivee) {
    List<LatLng> points = [];
    
    double midLat = (depart.latitude + arrivee.latitude) / 2;
    double midLng = (depart.longitude + arrivee.longitude) / 2;
    
    double offset = 0.7;
    
    LatLng pointCentral = LatLng(midLat + offset, midLng);

    for (int i = 0; i <= 50; i++) {
      double val = i / 50;
      double lat = (1 - val) * (1 - val) * depart.latitude +
          2 * (1 - val) * val * pointCentral.latitude +
          val * val * arrivee.latitude;
      double lng = (1 - val) * (1 - val) * depart.longitude +
          2 * (1 - val) * val * pointCentral.longitude +
          val * val * arrivee.longitude;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final curvePoints = _generateBezierPoints(posDepart, posArrivee);
    final bounds = LatLngBounds.fromPoints(curvePoints);
    
    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.iuto.app_mobile',
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: curvePoints,
              color: Colors.blue,
              strokeWidth: 4.0,
              pattern: StrokePattern.dashed(segments: [10, 10]),
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: posArrivee,
              child: const Icon(Icons.location_pin, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
