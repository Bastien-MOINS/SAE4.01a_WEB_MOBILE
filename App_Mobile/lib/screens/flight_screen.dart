import 'package:app_mobile/models/airport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/flight.dart';
import '../repositories/flight_repository.dart';
import 'map.dart' as custom_map;
import 'package:latlong2/latlong.dart';

class FlightScreen extends StatelessWidget{
  const FlightScreen({
    super.key, 
    required this.flight, 
    required this.departAirport, 
    required this.arriveeAirport,
    this.returnFlights,
    this.airportsMap,
    this.compagniesMap,
    this.allerFlight,
  });
  
  final Flight flight;
  final Airport departAirport;
  final Airport arriveeAirport;
  final List<Flight>? returnFlights;
  final Map<int, dynamic>? airportsMap;
  final Map<int, dynamic>? compagniesMap;
  final Flight? allerFlight;

  @override
  Widget build(BuildContext context) {
      List<Flight> volsRetours = [];
      if (returnFlights != null) {
        volsRetours = returnFlights!.where((f) => f.numeroAeroportDepart == flight.numeroAeroportArrivee).toList();
      }
      bool unRetour = volsRetours.isNotEmpty;

      return Scaffold(
        appBar: AppBar(
          title: Text(unRetour ? "Choisir le vol de retour" : "Vol N°${flight.numeroVol}"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Card(
                child: Column(
                  children: [
                    Text(flight.numeroVol.toString()),
                    SizedBox(height: 300, width: 400, child: custom_map.Map(
                      posDepart: LatLng(departAirport.latitude, departAirport.longitude),
                      posArrivee: LatLng(arriveeAirport.latitude, arriveeAirport.longitude),
                    )),
                    Text("depart lat ${departAirport.latitude}"),
                    Text("depart long ${departAirport.longitude}"),
                    Text("arrivee lat ${arriveeAirport.latitude}"),
                    Text("arrivee long ${arriveeAirport.longitude}"),
                    if (!unRetour)
                      ElevatedButton(
                          onPressed: () async {
                            await FlightRepository().saveFlight(flight);
                            if (allerFlight != null) {
                              await FlightRepository().saveFlight(allerFlight!);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Vol(s) réservé(s) avec succès"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: Text("Réserver"))
                  ],
                ),
              )),
              if (unRetour) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Sélectionnez votre vol retour :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: volsRetours.length,
                  itemBuilder: (context, index) {
                    return volsRetours[index].toWidget(context, airportsMap!, compagniesMap!, returnFlights: null, allerFlight: flight);
                  }
                ),
              ],
            ],
          ),
        ),
      );
  }

}