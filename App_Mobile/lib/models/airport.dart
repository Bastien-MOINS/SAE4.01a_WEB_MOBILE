import 'package:app_mobile/screens/flight_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Airport {
  int numeroAeroport;
  String nomAeroport;
  String ville;
  double latitude;
  double longitude;

  Airport({
    required this.numeroAeroport,
    required String this.nomAeroport,
    required String this.ville,
    required this.latitude,
    required this.longitude
  });

  factory Airport.fromJson(dynamic json) {
    return Airport(
        numeroAeroport: json['numero_vol'],
        nomAeroport: json['nom_aeroport'],
        ville: json['ville'],
        latitude: json['latitude'],
        longitude: json['longitude']
    );
  }
}