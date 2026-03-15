import 'dart:convert';
import 'dart:io';
import 'package:app_mobile/models/flight.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Flight>> getFlights() async {
    String url = "127.0.0.1";

    if (!kIsWeb && Platform.isAndroid) {
      url = "10.0.2.2";
    }
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
}