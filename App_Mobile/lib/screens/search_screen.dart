import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api.dart';
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

  List<Flight> _flights = [];
  List<Flight> _retourFlights = [];
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
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await api.getFlights(
        villeDepart: _departureController.text,
        villeArrivee: _arrivalController.text,
        dateDepart: _dateDepart?.toIso8601String().substring(0, 10),
        dateRetour: _dateRetour?.toIso8601String().substring(0, 10),
      );
      final airports = await api.getAirportsMap();
      final compagnies = await api.getCompagniesMap();
      
      setState(() {
        _flights = results['aller'] ?? [];
        _retourFlights = results['retour'] ?? [];
        _airports = airports;
        _compagnies = compagnies;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des vols')),
      );
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
                return _flights[index].toWidget(context, _airports, _compagnies, returnFlights: _retourFlights.isNotEmpty ? _retourFlights : null);
              }
            ),
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
                    if (value != null) {
                      setState(() {
                        _selectedSegment = value;
                      });
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
