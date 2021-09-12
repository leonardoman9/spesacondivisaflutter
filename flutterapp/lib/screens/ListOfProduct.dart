
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/controller/EditProduct.dart';
import 'package:flutterapp/controller/newProduct.dart';
import 'package:flutterapp/model/Prodotto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/screens/ListOfShop.dart';
import 'package:flutterapp/screens/Statistics.dart';
import 'package:flutterapp/screens/authentication/login.dart';

import 'Saldo.dart';

///Schermata che mostra tutti i prodotti da comprare inseriti da un gruppo

class ListOfProduct extends StatefulWidget {
  const ListOfProduct({Key? key, required this.idgroup}) : super(key: key);
  final String idgroup;

  // final FirebaseApp app;

  @override
  ListOfProductState createState() => ListOfProductState(idgroup);
}

class ListItem<String> {
  bool isSelected = false; //Selection property to highlight or not
  String data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class ListOfProductState extends State<ListOfProduct> {
  String idgroup;

  late DatabaseReference searchproducts;
  List<String> list = [];

  List<String> list2 = [];

  late List<ListItem> prodotti;

  User? user = FirebaseAuth.instance.currentUser;

  ListOfProductState(this.idgroup);

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
    searchproducts
        .child(idgroup.toString())
        .child("prodotti")
        .once()
        .then((DataSnapshot? snapshot) {
      Map<dynamic, dynamic>.from(snapshot!.value).forEach((key, value) {
        setState(() {
          if (value['buy'].toString() == '0') {
            list.add(value['nome'].toString());
            list2.add(key.toString());
            populateData(list.length);
          } else {}
        });
      });
    });
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  int _selectedIndex = 0;

  /**
   * Opzioni della bottom navigation bar
   */
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Spese'),
    Text('Index 2: Saldo'),
    Text('Index 3: Statistiche'),
  ];
  void _onItemTapped(int index) {
    setState((){
      switch(index){
        case 0: break;
        case 1:   Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfShop(idgroup: idgroup))); break;
        case 2: Navigator.push(context,
            MaterialPageRoute(builder: (context) => Saldo(idgroup: idgroup))); break;
        case 3: Navigator.push(context,
            MaterialPageRoute(builder: (context) => Statistics(idgroup: idgroup))); break;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Prodotti")),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          if (prodotti[index].isSelected) {
                            setState(() {
                              prodotti[index].isSelected = false;
                            });
                          }
                          else
                          { bool hasSelected = false;
                          for (int i=0; i < prodotti.length; i++){
                            if (prodotti[i].isSelected == true) hasSelected=true;
                          }
                          if (hasSelected==true){
                            setState(() {
                              prodotti[index].isSelected = true;
                            });
                          } else{
                             Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditProduct(idgroup: idgroup,idproduct: list2[index])));

                          }}
                          print('Container clicked ${list2[index]}');
                        },
                        onLongPress: () {
                          setState(() {
                            prodotti[index].isSelected = true;
                            print('Container clicked ${prodotti[0].isSelected.toString()}');
                          });
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(2),
                          color: prodotti[index].isSelected
                              ? Colors.red[100]
                              : Colors.blue[400],
                          //  msgCount[index]>3? Colors.blue[100]: Colors.grey
                          child: Center(
                            child: Text(
                              '${list[index]}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ));
                  })),
          SizedBox(height: 25.0),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.blue,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                _showMyDialog();
              },
              child: Text("Compra",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
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
                title: const Text('Log out'),
                onTap: () {
                  signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          ),
        ),

       floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => newProduct(idgroup: idgroup)));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  void populateData(int lenght) {
    prodotti = [];
    for (int i = 0; i < lenght; i++) {
      prodotti.add(ListItem(list2[i]));
    }
  }

  /**
   * Prompt di conferma per la spesa, richiede il prezzo pagato e il nome della spesa effettuata
   */
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma spesa'),
          content: SingleChildScrollView(

            child: Container(
            height: 300.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: ListView(
              children: <Widget>[
                TextField(
                  controller: totale,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Prezzo'),
                ),
                TextField(
                  controller: spesaNome,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Nome Spesa',
                  ),
                ),
              ],
            ),),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Conferma'),
              onPressed: () {
                insertSpesa();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Saldo(idgroup: idgroup);
                  }),
                );
              },
            ),
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /**
   * Inserisce la spesa effettuata tra le spese del gruppo
   */
  void insertSpesa() {
    var keysProdotti = Map<String, String>();
    int i = 0;
    prodotti.forEach((element) {
      if (element.isSelected) {
        keysProdotti[i.toString()] = element.data;
        i++;
      }});
      String spesaid = searchproducts.child("spese").push().key.toString();
      searchproducts
          .child(idgroup.toString())
          .child("spese")
          .child(spesaid)
          .child("idutente")
          .set(user?.email.toString().replaceAll(".", "'"));
      searchproducts
          .child(idgroup.toString())
          .child("spese")
          .child(spesaid)
          .child("nomeutente")
          .set(user?.displayName.toString());
      searchproducts
          .child(idgroup.toString())
          .child("spese")
          .child(spesaid)
          .child("nomespesa")
          .set(spesaNome.text.toString());
      searchproducts
          .child(idgroup.toString())
          .child("spese")
          .child(spesaid)
          .child("totale")
          .set(totale.text.toString());
      searchproducts
          .child(idgroup.toString())
          .child("spese")
          .child(spesaid)
          .child("prodotti")
          .set(keysProdotti)
          .whenComplete(() => changeBuyBit(keysProdotti));

  }

  /**
   * Setta lo stato del prodotto a "comprato"
   */
  void changeBuyBit(Map<String, String> keysProdotti) {
    keysProdotti.values.forEach((element) {
      searchproducts
          .child(idgroup)
          .child("prodotti")
          .child(element)
          .child("buy")
          .set("1");
    });
  }
}