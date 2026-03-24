import 'package:app_mobile/models/api.dart';
import 'package:app_mobile/screens/flight_screen.dart';
import 'package:flutter/material.dart';
import 'airport.dart';
import 'api.dart';
import 'package:intl/intl.dart';

class Flight {
  int numeroVol;
  late DateTime dateHeureDepart;
  late DateTime dateHeureArrivee;
  int idCompagnie;
  int numeroAeroportDepart;
  int idTerminalDepart;
  int numeroAeroportArrivee;
  int idTerminalArrivee;
  double latitude;
  double longitude;

  Flight({
    required this.numeroVol,
    required String dateDepart,
    required String heureDepart,
    required String dateArrivee,
    required String heureArrivee,
    required this.idCompagnie,
    required this.numeroAeroportDepart,
    required this.idTerminalDepart,
    required this.numeroAeroportArrivee,
    required this.idTerminalArrivee,
    required this.latitude,
    required this.longitude
  }) {
    dateHeureDepart = DateTime.parse('$dateDepart $heureDepart');
    dateHeureArrivee = DateTime.parse('$dateArrivee $heureArrivee');
  }

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
        numeroVol: json['numero_vol'],
        dateDepart: json['date_debut'].toString(),
        heureDepart: json['heure_debut'].toString(),
        dateArrivee: json['date_arrivee'].toString(),
        heureArrivee: json['heure_arrivee'].toString(),
        idCompagnie: json['id_compagnie'],
        numeroAeroportDepart: json['numero_aeroport_dep'],
        idTerminalDepart: json['id_terminal_dep'],
        numeroAeroportArrivee: json['numero_aeroport_arr'],
        idTerminalArrivee: json['id_terminal_arr'],
        latitude: (json['latitude'] ?? 0.0).toDouble(),
        longitude: (json['longitude'] ?? 0.0).toDouble()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero_vol': numeroVol,
      'date_debut': DateFormat('yyyy-MM-dd').format(dateHeureDepart),
      'heure_debut': DateFormat('HH:mm:ss').format(dateHeureDepart),
      'date_arrivee': DateFormat('yyyy-MM-dd').format(dateHeureArrivee),
      'heure_arrivee': DateFormat('HH:mm:ss').format(dateHeureArrivee),
      'id_compagnie': idCompagnie,
      'numero_aeroport_dep': numeroAeroportDepart,
      'id_terminal_dep': idTerminalDepart,
      'numero_aeroport_arr': numeroAeroportArrivee,
      'id_terminal_arr': idTerminalArrivee,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Widget toWidget(BuildContext context, Map<int, dynamic> airports, Map<int, dynamic> compagnies, {List<Flight>? returnFlights, Flight? allerFlight}) {
    final depart = airports[numeroAeroportDepart];
    final arrivee = airports[numeroAeroportArrivee];
    final compagnie = compagnies[idCompagnie];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightScreen(
                flight: this,
                departAirport: Airport.fromJson(depart),
                arriveeAirport: Airport.fromJson(arrivee),
                returnFlights: returnFlights,
                airportsMap: airports,
                compagniesMap: compagnies,
                allerFlight: allerFlight,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flight_takeoff, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    compagnie?['nom_compagnie'] ?? "Compagnie $idCompagnie",
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
                        Text(depart?['nom_aeroport'] ??
                            "ID $numeroAeroportDepart",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(depart?['ville'] ?? "", style: const TextStyle(
                            color: Colors.blueGrey)),
                        Text(DateFormat('dd/MM/yyyy').format(dateHeureDepart), style: const TextStyle(fontWeight: FontWeight.bold),),
                        Text(DateFormat.Hm().format(dateHeureDepart), style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  const Icon(
                      Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("ARRIVÉE", style: TextStyle(
                            color: Colors.grey, fontSize: 10)),
                        Text(arrivee?['nom_aeroport'] ??
                            "ID $numeroAeroportArrivee",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text(arrivee?['ville'] ?? "", style: const TextStyle(
                            color: Colors.blueGrey)),
                        Text(DateFormat('dd/MM/yyyy').format(dateHeureArrivee), style: const TextStyle(fontWeight: FontWeight.bold),),
                        Text(DateFormat.Hm().format(dateHeureArrivee), style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
