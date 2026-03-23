import 'package:flutter/material.dart';
import '../models/AuthRepository.dart';
import 'main_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Mon Profil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.blue[900],
        toolbarHeight: 85,
      ),
      body: FutureBuilder<List<String>>(
        future: AuthRepository().getUser(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return const Center(child: Text("Erreur de chargement"));
          }
          final userData = asyncSnapshot.data ?? ["", ""];
          final String pseudo = userData[0];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text("Bienvenue, $pseudo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  child: Text("Déconnexion",
                  style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    await AuthRepository().disconnection();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen())
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Déconnexion réussie"),
                        duration: const Duration(seconds: 1)),
                    );
                  }
                ),
              ],
            )
          );
        }
      )
    );
  }
}