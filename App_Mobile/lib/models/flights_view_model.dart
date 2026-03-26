import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import '../repositories/flight_repository.dart';

/// Implémente le ViewModel pour la gestion des vols 
/// Permet de centraliser et conserver en état les vols réservés par l'utilisateur
class FlightsViewModel extends ChangeNotifier {
  late List<Flight> _bookedFlights;
  late FlightRepository _flightRepository;
  List<Flight> get bookedFlights => _bookedFlights;
  FlightsViewModel() {
    _bookedFlights = [];
    _flightRepository = FlightRepository();
    getBookedFlights();
  }

  /// Permet d'ajouter un vol réservé à la liste actuelle
  /// Sauvegarde ensuite ce vol dans les SharedPreferences via le [FlightRepository] et notifie l'interface
   void addBookedFlight(Flight flight) {
     _bookedFlights.add(flight);
    _flightRepository.saveFlight(flight);
    notifyListeners();
  }

  /// Récupère l'ensemble des vols réservés stockés dans les SharedPreferences
  Future<void> getBookedFlights() async {
    _bookedFlights = await _flightRepository.getSavedFlights();
    notifyListeners();
  }
}