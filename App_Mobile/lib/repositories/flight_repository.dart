import 'dart:convert';
import 'package:app_mobile/models/flight.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// Implémente les méthodes pour stocker
/// et récupérer des vols dans les SharedPreferences
class FlightRepository {
  static const BOOKED_FLIGHTS_KEY = "booked_flights";
  /// Sauvegarde un vol réservé dans les SharedPreferences.
  ///
  /// Récupère tous les vols sauvegardés, vérifie que le [flight] n'existe pas
  /// puis ajoute le [flight]
  ///
  /// 
  ///
  /// Retourne un [Future<Void>]
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
  /// Récupère une [Future<List<Flight>>] correspondant au volsréservé dans les shared preferences.
  ///
  /// Récupère tous les vols sauvegardés, vérifie que la liste n'est pas null
  /// traduit le Json en une liste d'objets
  ///
  /// 
  ///
  /// Retourne un [Future<List<Flight>>]
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
    return flightsList;
  }
}