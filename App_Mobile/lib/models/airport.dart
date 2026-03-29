import 'package:app_mobile/screens/flight_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Représente un aéroport
/// Centralise les informations essentielles d'un aéroport
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

  /// Instancie un aéroport à partir de json
  factory Airport.fromJson(dynamic json) {
    return Airport(
        numeroAeroport: json['numero_aeroport'],
        nomAeroport: json['nom_aeroport'],
        ville: json['ville'],
        latitude: (json['latitude'] ?? 0.0).toDouble(),
        longitude: (json['longitude']?? 0.0).toDouble()
    );
  }
}