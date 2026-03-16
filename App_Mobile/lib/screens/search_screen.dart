import 'package:app_mobile/models/flight.dart';
import 'package:flutter/material.dart';
import '../models/api.dart';
class SearchScreen extends StatelessWidget{
  final api = Api();
  late final Future<List<Flight>> _flights = api.getFlights();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Flight>>(
                future: _flights,
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  if(snapshot.hasData && snapshot.data!.isNotEmpty){
                    final flight = snapshot.data?[0];
                    return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data?.length??0,
                        itemBuilder: (context, index){
                          return snapshot.data![index].toWidget(context);
                        }
                    );
                  }

                  if (snapshot.hasError){
                    print("${snapshot.error}");
                    return Center(child: Text("Erreur : ${snapshot.error}"),);
                  }
                  return Container();
                },
              ),
            ),
          ],
        )
    );
  }
}