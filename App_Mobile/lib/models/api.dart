import 'dart:convert';
import 'dart:io';
import 'package:app_mobile/models/airport.dart';
import 'package:app_mobile/models/flight.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Implémente les méthodes pour communiquer avec l'API REST
/// Effectue l'ensemble des requêtes HTTP nécessaires au fonctionnement de l'app
class Api {
  String url = "localhost";

  /// Vérifie et adapte l'URL du serveur selon la plateforme
  void _checkUrl() {
    if (!kIsWeb && Platform.isAndroid) {
      url = "10.0.2.2";
    }
  }

  /// Permet de récupérer des vols en fonction de différents paramètres
  /// Retourne un [Future<Map<String, List<Flight>>>] contenant les vols allers et potentiellement retours
  Future<Map<String, List<Flight>>> getFlights({String? villeDepart, String? villeArrivee, String? dateDepart, String? dateRetour}) async {
    _checkUrl();
    
    Map<String, String> query = {};
    if (villeDepart != null && villeDepart.isNotEmpty) {
      query['villeDepart'] = villeDepart;
    }
    if (villeArrivee != null && villeArrivee.isNotEmpty) {
      query['villeArrivee'] = villeArrivee;
    }
    if (dateDepart != null && dateDepart.isNotEmpty) {
      query['DateDepart'] = dateDepart;
    }
    if (dateRetour != null && dateRetour.isNotEmpty) {
      query['DateRetour'] = dateRetour;
    }

    Uri uri = Uri.http("$url:5000", "/vol/", query.isNotEmpty ? query : null);
    
    final response = await http.get(uri);
    if (response.statusCode == 200){
      dynamic json = jsonDecode(response.body);
      final aller = <Flight>[];
      final retour = <Flight>[];
      
      if (json is Map<String, dynamic>) {
        if (json['aller'] != null) {
          for (var flight in json['aller']) {
            aller.add(Flight.fromJson(flight));
          }
        }
        if (json['retour'] != null) {
          for (var flight in json['retour']) {
            retour.add(Flight.fromJson(flight));
          }
        }
      } else {
        for (var flight in json){
          aller.add(Flight.fromJson(flight));
        }
      }
      
      return {'aller': aller, 'retour': retour};
    }else {
      throw Exception('Failed to load flights');
    }
  }
  static Map<int, dynamic>? _airportsMap;
  static Map<int, dynamic>? _compagniesMap;

  /// Récupère l'ensemble des aéroports à partir du serveur REST
  /// Retourne une [Map<int, dynamic>] correspondant à un dictionnaire des vols indexée par l'identifiant de l'aéroport
  Future<Map<int, dynamic>> getAirportsMap() async {
    if (_airportsMap != null) return _airportsMap!;
    _checkUrl();
    final response = await http.get(Uri.parse("http://$url:5000/aeroports"));
    if (response.statusCode == 200){
      List<dynamic> json = jsonDecode(response.body);
      _airportsMap = {for (var a in json) a['numero_aeroport']: a};
      return _airportsMap!;
    }else{
      throw Exception('Failed to load airports json');
    }
  }

  /// Récupère l'ensemble des compagnies aériennes depuis l'API REST
  /// Retourne une [Map<int, dynamic>] correspondant à un dictionnaire de compagnies indexée par l'identifiant de chaque compagnie
  Future<Map<int, dynamic>> getCompagniesMap() async {
    if (_compagniesMap != null) return _compagniesMap!;
    _checkUrl();
    final response = await http.get(Uri.parse("http://$url:5000/compagnies"));
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      _compagniesMap = {for (var c in json) c['id_compagnie']: c};
      return _compagniesMap!;
    } else {
      throw Exception('Failed to load compagnies json');
    }
  }

  /// Récupère un aéroport grâce à son numéro via l'API REST
  /// Retourne un [Airport]
  Future<Airport> getAirport(int index) async {
    _checkUrl();
    final response = await http.get(Uri.parse("http://$url:5000/aeroports/$index"));
    if (response.statusCode == 200){
      dynamic json = jsonDecode(response.body);
      return Airport.fromJson(json);
    }else{
      throw Exception('Failed to load flight N°$index');
    }

  }
}