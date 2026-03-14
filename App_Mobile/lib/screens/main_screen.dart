import 'package:app_mobile/screens/home_screen.dart';
import 'package:app_mobile/screens/map_screen.dart';
import 'package:app_mobile/screens/search_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int currentIndex = 0;
  final List<Widget> screens = [HomeScreen(), MapScreen(), SearchScreen()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Vol',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label:  'Acceuil'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Rechercher'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Carte'
              )
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