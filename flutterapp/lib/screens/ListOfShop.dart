import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/Prodotto.dart';
import 'package:flutterapp/controller/newProduct.dart';
import 'package:flutterapp/controller/newgroup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../controller/EditProduct.dart';
import 'ListOfProduct.dart';
import 'ListOfProductBought.dart';
import 'Saldo.dart';
import 'Statistics.dart';

/**
 * Lista delle spese effettuate da un gruppo
 */

class ListOfShop extends StatefulWidget {
  const ListOfShop({Key? key, required this.idgroup}) : super(key: key);
  final String idgroup;

  // final FirebaseApp app;

  @override
  ListOfShopState createState() => ListOfShopState(idgroup);
}


class ListOfShopState extends State<ListOfShop> {
  String idgroup;

  late DatabaseReference searchproducts;
  List<String> nameShop = [];
  List<String> whobuy = [];
  List<double> price = [];
  List<String> idshop = [];

  List<String> utenti = [];
  
  String miaSpesa="";
  String spesaTotale="";
  


  User? user = FirebaseAuth.instance.currentUser;

  ListOfShopState(this.idgroup);
  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(
        databaseURL:
        "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");
    searchproducts = database.reference().child("gruppi");

    //String? child=user?.email.toString().replaceAll('.','');
    searchproducts
        .child(idgroup).child("spese").once().then((DataSnapshot? snapshot) {
      Map<dynamic, dynamic>.from(snapshot!.value).forEach((key, value) {
        setState(() {
            idshop.add(key.toString());
            nameShop.add(value["nomespesa"].toString());
            whobuy.add(value["nomeutente"].toString().toUpperCase());
            price.add(double.parse(value["totale"].toString()));
        });
      });
    });
    searchproducts
        .child(idgroup).child("gruppo").once().then((DataSnapshot? snapshot) {
      Map<dynamic, dynamic>.from(snapshot!.value).forEach((key, value) {
        setState(() {
          utenti.add(key.toString());
        });
      });
      setState(() {
        double sum = 0.00;
        price.forEach((double e){sum += e;});
        spesaTotale=sum.toStringAsFixed(2);
        miaSpesa=(sum/utenti.length).toStringAsFixed(2);
      });
    });


  }
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Spese'),
    Text('Index 2: Saldo'),
    Text('Index 3: Statistiche'),
  ];
  void _onItemTapped(int index) {
    setState((){
      switch(index){
        case 0:  Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfProduct(idgroup: idgroup))); break;
        case 1:   break;
        case 2: Navigator.push(context,
            MaterialPageRoute(builder: (context) => Saldo(idgroup: idgroup))); break;
        case 3: Navigator.push(context,
            MaterialPageRoute(builder: (context) => Statistics(idgroup: idgroup))); break;
      }
      _selectedIndex = index;
    });}
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Spese")),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: idshop.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ListOfProductBought(idgroup: idgroup,idshop: idshop[index])));
                            
                        },
                        
                        child: Container(
                      height: 50,
                      margin: EdgeInsets.all(2),
                      color: Colors.blue[400],
                      //  msgCount[index]>3? Colors.blue[100]: Colors.grey
                      child: Column(
                          children: <Widget>[
                            Row(
                    children: <Widget>[
                      Expanded(child: Text(
                        '${nameShop[index]}',
                        style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                      ),),
                    Expanded(child:  Text(
                      ' ${price[index].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 22),
                    ),)


                      
                    ]
                    ),
                            Text(
                            'Acquistato da :${whobuy[index]}',
                            style: TextStyle(fontSize: 15),
                          ),
                          ]
                      ),
                    ),);})),
          Card(child:
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(
                        'Mia Spesa',
                        style: TextStyle(fontSize: 18),
                      ),),
                      Expanded(child: Text(
                        ' Spesa Totale',
                        style: TextStyle(fontSize: 18),
                      ),)


                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text(
                        '${miaSpesa}€',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),),
                      Expanded(child: Text(
                        ' ${spesaTotale}€',
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),)



                    ],
                  ),
                ],
              ))


        ]),
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
                child: Text('Statistiche'),
              ),
              ListTile(
                title: const Text('Statistica 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Statistica 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

      ),
    );
  }







}