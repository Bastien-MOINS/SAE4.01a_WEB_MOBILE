import 'package:flutter/material.dart';
import 'connection_screen.dart';

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 35
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  print("Le rond a été cliqué !");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('assets/images/logo_bleu2.png'),
                ),
              ),
            ),
          ]
      ),
      body: Container(
        child: Text("Prochains Vols")
      )
    );

  }
}