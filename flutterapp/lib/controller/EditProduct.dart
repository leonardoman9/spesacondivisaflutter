
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/ListOfProduct.dart';
import 'package:flutterapp/model/Prodotto.dart';

/**
 * Per modificare un prodotto di un gruppo
 */
class EditProduct extends StatelessWidget {
  EditProduct({Key? key, required this.idgroup,required this.idproduct}) : super(key: key);
  final String idgroup;
  final String idproduct;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InserisciProdotto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:MyHomePage(idgroup: idgroup,idproduct: idproduct,),
    );
  }


}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.idgroup, required this.idproduct}) : super(key: key);
  final String idgroup;
  final String idproduct;
  @override
  _MyHomePageState createState() => _MyHomePageState(idgroup,idproduct);
}

class _MyHomePageState extends State<MyHomePage> {

  String idgroup;
  String idproduct;
  _MyHomePageState(this.idgroup,this.idproduct);

  var list = Map<String, String>();
  String dropdownValuecategoria = 'Seleziona categoria';
  String dropdownValuequantita = 'Seleziona quantità';

  final FirebaseDatabase database = FirebaseDatabase(databaseURL: "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");


  User? user= FirebaseAuth.instance.currentUser;


  final nomeProdotto = TextEditingController();
  final note = TextEditingController();


  @override
  void initState() {
    super.initState();
    DatabaseReference myRef= database.reference().child("gruppi");


    myRef.child(idgroup).child("prodotti").child(idproduct).once().then((DataSnapshot? snapshot) {

        setState(() {
          nomeProdotto.text=snapshot!.value["nome"].toString();
          dropdownValuecategoria=snapshot.value["categoria"].toString();
          dropdownValuequantita=snapshot.value["quantita"].toString();
          note.text=snapshot.value["note"].toString();

        });


      });


  }

  /**
   * Aggiorna il prodotto nel database.
   */
  void updateProduct(){
      DatabaseReference myRef= database.reference().child("gruppi");
      myRef.child(idgroup).child("prodotti").child(idproduct).child("nome").set(nomeProdotto.text.toString());
      myRef.child(idgroup).child("prodotti").child(idproduct).child("categoria").set(dropdownValuecategoria);
      myRef.child(idgroup).child("prodotti").child(idproduct).child("quantita").set(dropdownValuequantita);
      myRef.child(idgroup).child("prodotti").child(idproduct).child("note").set(note.text.toString());

  }





  void delete() {
    DatabaseReference myRef= database.reference().child("gruppi");
    myRef.child(idgroup).child("prodotti").child(idproduct).remove();

  }



  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final nameProductField = TextField(
      obscureText: false,
      style: style,
      controller: nomeProdotto,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nome Prodotto",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final categoria =DropdownButton<String>(
      value: dropdownValuecategoria,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValuecategoria = newValue!;
        });
      },
      items: <String>['Seleziona categoria', 'Cibo', 'Bagno', 'Casa', 'Salute', 'Divertimento', 'Altro']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
    final quantita =DropdownButton<String>(
      value: dropdownValuequantita,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValuequantita = newValue!;
        });
      },
      items: <String>['Seleziona quantità', '1', '2', '3', '4', '5', '6','7','8','9','9+']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );


    final noteField = TextField(
      obscureText: false,
      style: style,
      controller: note,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Note",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );




    final editButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          updateProduct();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListOfProduct(idgroup: idgroup)));
        },
        child: Text("Modifica",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );
    final deleteButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          showAlertDialog(context);

        },
        child: Text("Elimina",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );



    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Text("Nome Prodotto"),
                    nameProductField,
                    SizedBox(height: 45.0),
                    categoria,
                    SizedBox(height: 45.0),
                    quantita,
                    SizedBox(height: 45.0),
                    Text("Note"),
                    noteField,
                    SizedBox(
                      height: 15.0,
                    ),
                    editButton,
                    SizedBox(
                      height: 15.0,
                    ),
                    deleteButton,
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      onPressed: () => Navigator.pop(context, 'NO'),
      child: const Text('NO'),
    );
    Widget continueButton = TextButton(
      child: Text("Si"),
      onPressed:  () {
        delete();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ListOfProduct(idgroup: idgroup)));

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Elimina"),
      content: Text("Sei Sicuro di voler eliminare: ${nomeProdotto.text}"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

