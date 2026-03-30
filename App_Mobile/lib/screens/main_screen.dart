import 'package:app_mobile/screens/home_screen.dart';
import 'package:app_mobile/screens/search_screen.dart';
import 'package:flutter/material.dart';

/// Implémente la vue racine permettant la navigation dans l'appli
/// Gère la barre de navigation inférieure entre [HomeScreen], [SearchScreen] et [MapScreen] via une [BottomNavigationBar]
class MainScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

/// Gère l'état et l'index actuel de la [BottomNavigationBar]
class _MainScreenState extends State<MainScreen>{
  int currentIndex = 0;
  final List<Widget> screens = [HomeScreen(), SearchScreen()];
  
  /// Construit le widget principal [MaterialApp]
  /// Configure le thème général de l'application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Vol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade900,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 6,
          color: Colors.white,
          surfaceTintColor: Colors.blue.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
      ),
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label:  'Accueil'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Rechercher'
              ),
            ],
            currentIndex: currentIndex,
            onTap: (int index){
              setState(() {
              currentIndex = index;
            });},
        ),
    ),
    );
  }

}