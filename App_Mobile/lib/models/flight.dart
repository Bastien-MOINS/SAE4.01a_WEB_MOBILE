import 'package:app_mobile/models/api.dart';
import 'package:app_mobile/screens/flight_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'airport.dart';
import 'api.dart';

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
      longitude: (json['longitude']?? 0.0).toDouble()
    );
  }

  Widget toWidget(BuildContext context){

    return ListTile(
      title: Text("Vol N°$numeroVol"),
      trailing: Text('trailing'),
      subtitle: Text('sous titre'),
      isThreeLine: true,
      onTap: () async {
        Api api = Api();
        Airport Airportdepart = await api.getAirport(numeroAeroportDepart);
        Airport Airportarrivee = await api.getAirport(numeroAeroportArrivee);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => FlightScreen(flight: this, departAirport: Airportdepart, arriveeAirport: Airportarrivee)
          )
        );
      },
    );
  }
}