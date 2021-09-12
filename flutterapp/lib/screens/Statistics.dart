

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/screens/ListOfProduct.dart';
import 'package:flutterapp/screens/ListOfShop.dart';
import 'package:flutterapp/screens/authentication/login.dart';
import 'package:pie_chart/pie_chart.dart';

import 'Saldo.dart';

/**
 * Schermata per le statistiche: la statistica visualizzata è la percentuale di categorie di prodotti pi
 *  acquistate da un gruppo. Utilizza la libreria PieChart
 */

class Statistics extends StatefulWidget {
  const Statistics({Key? key, required this.idgroup}) : super(key: key);
  final String idgroup;

  // final FirebaseApp app;

  @override
  StatisticsState createState() => StatisticsState(idgroup);
}


class StatisticsState extends State<Statistics> {
  String idgroup;

  late DatabaseReference searchproduct;
  List<String> categorie=["Cibo", "Bagno", "Casa", "Salute", "Divertimento", "Altro"];
  List<double> quantita=[0,0,0,0,0,0] ;



  Map<String, double> dataMap=Map();

  User? user= FirebaseAuth.instance.currentUser;

  StatisticsState(this.idgroup);


  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(databaseURL: "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");
    searchproduct= database.reference().child("gruppi");

    searchproduct.child(idgroup.toString()).child("prodotti").once().then((DataSnapshot? snapshot) {
      if (snapshot!.value==null) {
        setState(() {
          dataMap[""]=0;
        });


      }
      else{
        for (int i = 0; i < categorie.length; i++) {
          Map<dynamic, dynamic>.from(snapshot!.value).forEach((key, value) {
            if (value["buy"].toString() == "1" &&
                value["categoria"].toString() == categorie[i]) {
              setState(() {
                quantita[i] =
                    quantita[i] +
                        double.parse(value["quantita"].toString());
              });
            }
          });
          setState(() {
            dataMap[categorie[i]] = quantita[i];
          });
        }
    }




    });


  }
  int _selectedIndex = 3;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Spese'),
    Text('Index 2: Saldo'),
    Text('Index 3: Statistiche'),
  ];
  void _onItemTapped(int index) {
    setState((){
      switch(index){
        case 0: Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfProduct(idgroup: idgroup))); break;
        case 1:   Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfShop(idgroup: idgroup))); break;
        case 2: Navigator.push(context,
            MaterialPageRoute(builder: (context) => Saldo(idgroup: idgroup))); break;
        case 3: break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home:Scaffold(
        appBar: AppBar(title: Text("Lista della spesa")),
        body:PieChart( dataMap: dataMap,
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            decimalPlaces: 2,
          ),),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Spesa condivisa'),
              ),
              ListTile(
                title: const Text('Il mio account'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'Spese',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Saldo',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Statistiche',
              backgroundColor: Colors.red,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ));
  }
}












