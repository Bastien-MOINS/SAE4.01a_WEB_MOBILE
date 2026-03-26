import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api.dart';
/// Implémente la vue de recherche de vol avec filtres
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
/// Gère l'état de la page, selon le chargement et les données
class _SearchScreenState extends State<SearchScreen> {
  final api = Api();
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  List<Flight> _flights = [];
  List<Flight> _retourFlights = [];
  Map<int, dynamic> _airports = {};
  Map<int, dynamic> _compagnies = {};
  bool _isLoading = false;

  DateTime? _dateDepart;
  DateTime? _dateRetour;

  @override
  void initState() {
    super.initState();
    _searchFlights();
  }

  /// Effectue la recherche de vols via l'API, en utilisant les filtres choisis
  /// Met à jour l'état de l'application et l'affichage avec les résultats
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
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des vols')),
      );
    }
  }

  /// Construit le widget [Scaffold] correspondant à la vue de recherche
  /// Combine les filtres de recherche et l'affichage des résultats
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

  /// Construit la barre d'entête [SliverAppBar] avec le formulaire de filtres
  /// Contient les champs pour filtrer par villes et dates
  SliverAppBar appBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 250,
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
                        prefixIcon: Icon(Icons.location_pin, color: Colors.grey),
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
                        prefixIcon: Icon(Icons.location_pin, color: Colors.grey),
                        hintText: "Ville d'arrivée",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: calendarSelector("Date aller", _dateDepart, true)),
                  SizedBox(width: 8),
                  Expanded(child: calendarSelector("Date retour", _dateRetour, false)),
                ],
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _searchFlights,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  child: Text("Rechercher un vol"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Construit et retourne un sélecteur de date
  /// Affiche le [showDatePicker] lors d'un clic et met à jour l'état
  Widget calendarSelector(String title, DateTime? selectedDate, bool isDepart) {
    return GestureDetector(
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
          _searchFlights();
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
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate): title,
                style: TextStyle(
                  color: selectedDate != null ? Colors.black : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
