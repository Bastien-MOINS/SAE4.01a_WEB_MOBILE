import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import '../repositories/flight_repository.dart';

class FlightsViewModel extends ChangeNotifier {
  late List<Flight> _bookedFlights;
  late FlightRepository _flightRepository;
  List<Flight> get bookedFlights => _bookedFlights;
  FlightsViewModel() {
    _bookedFlights = [];
    _flightRepository = FlightRepository();
    getBookedFlights();
  }
   void addBookedFlight(Flight flight) {
     _bookedFlights.add(flight);
    _flightRepository.saveFlight(flight);
    notifyListeners();
  }
  Future<void> getBookedFlights() async {
    _bookedFlights = await _flightRepository.getSavedFlights();
    notifyListeners();
  }
}