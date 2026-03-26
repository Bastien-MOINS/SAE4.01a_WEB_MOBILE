import 'package:app_mobile/repositories/flight_repository.dart';
import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/api.dart';

/// Implémente la vue d'accueil de l'application
/// Affiche la liste des vols réservés par l'utilisateur
class HomeScreen extends StatelessWidget{
  FlightRepository flightRepository = FlightRepository();
  
  /// Récupère l'ensemble des données nécessaires à l'affichage de la page
  /// Retourne un [Future<Map<String, dynamic>>] contenant les vols, aéroports et compagnies
  Future<Map<String, dynamic>> _loadData() async {
    Api api = Api();
    final flights = await flightRepository.getSavedFlights();
    final airports = await api.getAirportsMap();
    final compagnies = await api.getCompagniesMap();
    return {
      'flights': flights,
      'airports': airports,
      'compagnies': compagnies,
    };
  }

  /// Construit le widget [Scaffold] correspondant à la vue principale d'accueil
  /// Gère l'attente et l'affichage des données via un [FutureBuilder]
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _loadData(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasData && (snapshot.data!['flights']).isNotEmpty){
                    final flights = snapshot.data!['flights'];
                    final airports = snapshot.data!['airports'];
                    final compagnies = snapshot.data!['compagnies'];
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: flights.length,
                        itemBuilder: (context, index){
                          return flights[index].toWidget(context, airports, compagnies);
                        }
                    );
                  }

                  if (snapshot.hasError){
                    print("${snapshot.error}");
                    return Center(child: Text("Erreur : ${snapshot.error}"),);
                  }
                  return Container();
                },
              ),
            ),
          ],
        )
    );
  }
}