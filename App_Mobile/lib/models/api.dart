import 'dart:convert';
import 'dart:io';
import 'correspondence.dart';
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
  Future<Map<String, List<List<Flight>>>> getFlights({
    String? villeDepart,
    String? villeArrivee,
    String? dateDepart,
    String? dateRetour,
    Correspondence? correspondence,
  }) async {
    _checkUrl();

    Map<String, String> query = {};
    if (villeDepart?.isNotEmpty ?? false) query['villeDepart'] = villeDepart!;
    if (villeArrivee?.isNotEmpty ?? false) query['villeArrivee'] = villeArrivee!;
    if (dateDepart?.isNotEmpty ?? false) query['DateDepart'] = dateDepart!;
    if (dateRetour?.isNotEmpty ?? false) query['DateRetour'] = dateRetour!;
    if (correspondence != null) query['correspondence'] = correspondence.name;

    Uri uri = Uri.http("$url:5000", "/vol/", query.isNotEmpty ? query : null);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      final aller = <List<Flight>>[];

      // Fonction helper pour transformer le JSON en List de List
      List<Flight> parseTrip(dynamic item) {
        if (item is List) {
          return item.map((f) => Flight.fromJson(f)).toList();
        }
        return [Flight.fromJson(item)];
      }

      if (json is Map && json['aller'] != null) {
        for (var trip in json['aller']) {
          aller.add(parseTrip(trip));
        }
      }
      return {'aller': aller, 'retour': []};
    } else {
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