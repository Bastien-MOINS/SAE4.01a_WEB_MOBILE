import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/flight.dart';
import 'map.dart';
import 'package:latlong2/latlong.dart';

class FlightScreen extends StatelessWidget{
  const FlightScreen({super.key, required this.flight});
  final Flight flight;
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Vol N°${flight.numeroVol}"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text(flight.numeroVol.toString()),
                    SizedBox(height: 300, child: Map()),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

}