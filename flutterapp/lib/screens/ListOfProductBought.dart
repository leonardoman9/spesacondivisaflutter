import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/Prodotto.dart';
import 'package:flutterapp/controller/newProduct.dart';
import 'package:flutterapp/controller/newgroup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../controller/EditProduct.dart';
import 'Saldo.dart';

/**
 * Schermata che presenta i prodotti comprati
 */
class ListOfProductBought extends StatefulWidget {
  const ListOfProductBought({Key? key, required this.idgroup, required this.idshop}) : super(key: key);
  final String idgroup;
  final String idshop;

  // final FirebaseApp app;

  @override
  ListOfProductBoughtState createState() => ListOfProductBoughtState(idgroup,idshop);
}



class ListOfProductBoughtState extends State<ListOfProductBought> {
  String idgroup;
  String idshop;

  late DatabaseReference searchproducts;
  List<String> list = [];

  List<String> nomeProdotto = [];
  List<String> quantita = [];

  User? user = FirebaseAuth.instance.currentUser;

  ListOfProductBoughtState(this.idgroup,this.idshop);

  final spesaNome = TextEditingController();
  final totale = TextEditingController();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(
        databaseURL:
        "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");
    searchproducts = database.reference().child("gruppi");

    //String? child=user?.email.toString().replaceAll('.','');
    searchproducts.child(idgroup.toString()).child("spese").child(idshop).child("prodotti")
        .once()
        .then((DataSnapshot? snapshot) {
          List<dynamic>.from(snapshot!.value).forEach((element) {
            list.add(element);
          });
          list.forEach((element) {
            searchproducts.child(idgroup.toString()).child("prodotti").child(element)
                .once()
                .then((DataSnapshot? snapshot) {

                setState(() {
                  nomeProdotto.add(snapshot!.value["nome"]);
                  quantita.add(snapshot!.value["quantita"]);
                });

            });

          });
    });



  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: Text("ciao")),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          color: Colors.blue[400],
                          //  msgCount[index]>3? Colors.blue[100]: Colors.grey
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text(
                                '${nomeProdotto[index]}',
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                              ),),
                              Expanded(child: Text(
                                ' Qunatità: ${quantita[index]}',
                                style: TextStyle(fontSize: 18),
                              ),),

                            ]
                          ),
                        );
                  })),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.blue,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Lista Spese",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ]),
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