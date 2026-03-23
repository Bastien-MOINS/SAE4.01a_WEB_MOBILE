import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';

import '../models/AuthRepository.dart';

class InscrConectScreen extends StatefulWidget {
  const InscrConectScreen({Key? key}) : super(key: key);

  @override
  State<InscrConectScreen> createState() => _RegisterState();
}

class _RegisterState extends State<InscrConectScreen> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  bool _pageInscription = false;
  final TextEditingController _pseudoCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageInscription ? 'Inscription' : 'Connexion'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _pseudoCont,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Entrez votre pseudo'),
                    ]).call,

                    decoration: InputDecoration(
                      hintText: 'Entrez votre pseudo',
                      labelText: 'Pseudo',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius:
                        BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordCont,
                    obscureText: true,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Entrez votre mot de passe'),
                    ]).call,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre mot de passe',
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.blue,
                      ),
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius:
                        BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(_pageInscription ? 'Inscription' : 'Connexion',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        onPressed: () async{
                          if (_formkey.currentState!.validate()) {
                            String pseudo = _pseudoCont.text;
                            String password = _passwordCont.text;
                            if (_pageInscription) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              await AuthRepository().register(pseudo, password);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Inscription réussie !'),
                                  duration: const Duration(seconds: 1)),
                              );
                              setState(() {
                                _pageInscription = !_pageInscription;
                              });
                            } else {
                              bool reussie = await AuthRepository().login(pseudo, password);
                              if (!reussie) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Connection échoué (pseudo ou mdp inccorect)"),
                                    duration: const Duration(seconds: 1)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Connexion réussie !'),
                                    duration: const Duration(seconds: 1)),
                                );
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                      ),
                    ),
                  )),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        _pageInscription = !_pageInscription;
                      });
                    },
                    child: Text(
                      _pageInscription ? "Déjà un compte ? Se connecter" : "Pas de compte ? S'inscrire",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            )),
        ),
      ));
  }
}