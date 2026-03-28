import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import '../models/correspondence.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final api = Api();
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  List<List<Flight>> _flights = [];
  List<List<Flight>> _retourFlights = [];
  Map<int, dynamic> _airports = {};
  Map<int, dynamic> _compagnies = {};
  bool _isLoading = false;
  Correspondence _selectedSegment = Correspondence.direct;

  DateTime? _dateDepart;
  DateTime? _dateRetour;

  @override
  void initState() {
    super.initState();
    _searchFlights();
  }

  void _searchFlights() async {
    setState(() => _isLoading = true);

    try {
      final results = await api.getFlights(
        villeDepart: _departureController.text,
        villeArrivee: _arrivalController.text,
        dateDepart: _dateDepart?.toIso8601String().substring(0, 10),
        correspondence: _selectedSegment,
      );

      // Récupération des maps pour les noms d'aéroports/compagnies
      final airports = await api.getAirportsMap();
      final compagnies = await api.getCompagniesMap();

      setState(() {
        _flights = results['aller'] ?? [];
        _airports = airports;
        _compagnies = compagnies;
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur: $e");
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar(),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_flights.isEmpty)
            SliverFillRemaining(
              child: Center(child: Text('Aucun vol trouvé')),
            )
          else
            SliverList.builder(
              itemCount: _flights.length,
              itemBuilder: (BuildContext context, int index) {
                final trip = _flights[index];
                final int correspondences = trip.length - 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header showing trip type
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            correspondences == 0
                                ? "Vol Direct"
                                : "$correspondences Correspondance${correspondences > 1 ? 's' : ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: correspondences == 0 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                        const Divider(),
                        // Map each flight in the trip to its widget
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trip.length,
                          separatorBuilder: (context, i) {
                            // Get the city where the stopover happens
                            final airportId = trip[i].numeroAeroportArrivee;
                            final cityName = _airports[airportId]?['ville'] ?? 'Escale';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Chip(
                                      label: Text("Escale à $cityName"),
                                      backgroundColor: Colors.blue.shade50,
                                      labelStyle: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),
                            );
                          },
                          itemBuilder: (context, i) {
                            // Reuse your existing toWidget but with smaller margins if needed
                            return trip[i].toWidget(context, _airports, _compagnies);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _departureController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Ville de départ",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _arrivalController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Ville d'arrivée",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchFlights,
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  calendarSelector("Date aller", _dateDepart, true),
                  SizedBox(width: 8),
                  calendarSelector("Date retour", _dateRetour, false),
                  SizedBox(width: 48),
                ],
              ),
              SizedBox(height: 12),
              Center(
                child: CupertinoSlidingSegmentedControl<Correspondence>(
                  groupValue: _selectedSegment,
                  onValueChanged: (Correspondence? value) {
                    try{
                      setState(() {
                        _selectedSegment = value!;
                      });
                      _searchFlights();
                    }catch(e){
                      print(e);
                    }
                  },
                  children: const <Correspondence, Widget>{
                    Correspondence.direct: Text('Direct'),
                    Correspondence.one: Text('1 escale'),
                    Correspondence.two: Text('2 escales'),
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarSelector(String title, DateTime? selectedDate, bool isDepart) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (picked != null) {
            setState(() {
              if (isDepart) {
                _dateDepart = picked;
              } else {
                _dateRetour = picked;
              }
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate): title,
                style: TextStyle(
                  color: selectedDate != null ? Colors.black : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
