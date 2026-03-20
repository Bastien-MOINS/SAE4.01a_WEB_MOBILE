import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import '../models/api.dart';

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
  Map<int, dynamic> _airports = {};
  Map<int, dynamic> _compagnies = {};
  bool _isLoading = false;

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
      );
      final airports = await api.getAirportsMap();
      final compagnies = await api.getCompagniesMap();
      
      setState(() {
        _flights = results;
        _airports = airports;
        _compagnies = compagnies;
        _isLoading = false;
      });
    } catch (e) {
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
                return _flights[index].toWidget(context, _airports, _compagnies);
              }
            ),
        ],
      ),
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 90,
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
            ],
          ),
        ),
      ),
    );
  }
}
