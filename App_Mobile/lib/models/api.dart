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
  Future<List<Flight>> getFlights() async {
    _checkUrl();
    final response = await http.get(Uri.parse("http://$url:5000/vol/"));
    if (response.statusCode == 200){
      List<dynamic> json = jsonDecode(response.body);
      final _flights = <Flight>[];
      for (var flight in json){
        _flights.add(Flight.fromJson(flight));
      }
      return _flights;
    }else {
      throw Exception('Failed to load flights');
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