import 'package:app_mobile/screens/profil_screen.dart';
import 'package:flutter/material.dart';
import '../models/AuthRepository.dart';
import 'connection_screen.dart';

class HomeScreen extends StatelessWidget{
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
      body: Container(
        child: Text("Prochains Vols")
      )
    );

  }
}