import 'package:app_mobile/screens/profil_screen.dart';
import 'package:app_mobile/repositories/flight_repository.dart';
import 'package:flutter/material.dart';
import '../models/AuthRepository.dart';
import 'connection_screen.dart';
import '../models/flight.dart';
import '../models/api.dart';

class HomeScreen extends StatelessWidget{
  FlightRepository flightRepository = FlightRepository();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85,
        automaticallyImplyLeading: false,
        title: Image(image: AssetImage('assets/images/logo_bleu2_transparant.png'),
            height: 70),
        backgroundColor: Colors.blue[900],
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                onTap: () async {
                  if (await AuthRepository().isConnected()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InscrConectScreen(),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
              ),
            ),
          ]
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Mes prochains vols",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
          const SizedBox(height: 10),
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