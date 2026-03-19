import 'package:app_mobile/models/airport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/flight.dart';
import '../repositories/flight_repository.dart';
import 'map.dart';
import 'package:latlong2/latlong.dart';
import 'package:latlong2/latlong.dart';

class FlightScreen extends StatelessWidget{
  const FlightScreen({super.key, required this.flight, required this.departAirport, required this.arriveeAirport});
  final Flight flight;
  final Airport departAirport;
  final Airport arriveeAirport;
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
              Center(child: Card(
                child: Column(
                  children: [
                    Text(flight.numeroVol.toString()),
                    SizedBox(height: 300, width: 400, child: Map(
                      posDepart: LatLng(departAirport.latitude, departAirport.longitude),
                      posArrivee: LatLng(arriveeAirport.latitude, arriveeAirport.longitude),
                    )),
                    Text("depart lat ${departAirport.latitude}"),
                    Text("depart long ${departAirport.longitude}"),
                    Text("arrivee lat ${arriveeAirport.latitude}"),
                    Text("arrivee long ${arriveeAirport.longitude}"),
                    ElevatedButton(
                        onPressed: () async {
                          await FlightRepository().saveFlight(flight);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vol réservé avec succès !"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text("Réserver"))
                  ],
                ),
              )),
              Text("")
            ],
          ),
        ),
      );
  }

}