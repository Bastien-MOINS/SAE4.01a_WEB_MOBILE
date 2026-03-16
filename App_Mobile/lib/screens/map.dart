import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  LatLng posDepart;
  LatLng posArrivee;

  Map({required this.posDepart, required this.posArrivee});
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLngBounds.fromPoints([posDepart, posArrivee]).center,
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.iuto.app_mobile',
        ),
      ],
    );
  }
}