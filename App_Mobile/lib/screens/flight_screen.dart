import 'package:app_mobile/models/airport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
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
      final compagnie = compagniesMap?[flight.idCompagnie];
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
                    SizedBox(height: 300, width: 400, child: custom_map.Map(
                      posDepart: LatLng(departAirport.latitude, departAirport.longitude),
                      posArrivee: LatLng(arriveeAirport.latitude, arriveeAirport.longitude),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Informations du vol sélectionné : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    ),
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 200, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.flight, color: Colors.deepOrangeAccent),
                                const SizedBox(width: 8),
                                Text(
                                  compagnie?['nom_compagnie'] ?? "Compagnie ${flight.idCompagnie}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("DÉPART", style: TextStyle(
                                          color: Colors.grey, fontSize: 10)),
                                      Text(departAirport.nomAeroport,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(departAirport.ville, style: const TextStyle(
                                          color: Colors.blueGrey)),
                                      Text(DateFormat('dd/MM/yyyy').format(flight.dateHeureDepart), style: const TextStyle(fontWeight: FontWeight.bold),),
                                      Text(DateFormat.Hm().format(flight.dateHeureDepart), style: const TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                const Icon(
                                    Icons.arrow_forward_sharp, size: 16, color: Colors.grey),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("ARRIVÉE", style: TextStyle(
                                          color: Colors.grey, fontSize: 10)),
                                      Text(arriveeAirport.nomAeroport,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(arriveeAirport.ville, style: const TextStyle(
                                          color: Colors.blueGrey)),
                                      Text(DateFormat('dd/MM/yyyy').format(flight.dateHeureArrivee), style: const TextStyle(fontWeight: FontWeight.bold),),
                                      Text(DateFormat.Hm().format(flight.dateHeureArrivee), style: const TextStyle(fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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