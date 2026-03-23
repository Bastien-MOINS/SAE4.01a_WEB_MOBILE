import 'dart:convert';
import 'dart:io';
import 'package:app_mobile/models/airport.dart';
import 'package:app_mobile/models/flight.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Api {
  String url = "localhost";
  void _checkUrl() {
    if (!kIsWeb && Platform.isAndroid) {
      url = "10.0.2.2";
    }
  }
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