import 'dart:convert';
import 'package:app_mobile/models/flight.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FlightRepository {
  static const BOOKED_FLIGHTS_KEY = "booked_flights";

  Future<void> saveFlight(Flight flight) async {
    SharedPreferences sharedPreferences = await
    SharedPreferences.getInstance();
    List<Flight> flights = await getSavedFlights();
    if (!flights.any((f) => f.numeroVol == flight.numeroVol)) {
      flights.add(flight);
      List<String> jsonStrings = [];
      for (var f in flights) {
        jsonStrings.add(jsonEncode(f.toJson()));
      }

      await sharedPreferences.setStringList(BOOKED_FLIGHTS_KEY, jsonStrings);
    }
  }

  Future<List<Flight>> getSavedFlights() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? data = sharedPreferences.getStringList(BOOKED_FLIGHTS_KEY);

    if (data == null) return [];
    List<Flight> flightsList = [];

    for (String json in data) {
      Map<String, dynamic> flight = jsonDecode(json);
      Flight vol = Flight.fromJson(flight);
      flightsList.add(vol);
    }
    print(flightsList);
    return flightsList;
  }
}