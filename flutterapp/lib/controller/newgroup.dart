
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/groups.dart';
import '../model/Gruppo.dart';

/**
 * Crea un nuovo gruppo di utenti
 */
class NewGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:MyHomePage(title: 'NewGroup'),
    );
  }


}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, String? title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var list = Map<String, String>();

  final FirebaseDatabase database = FirebaseDatabase(databaseURL: "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");


  User? user= FirebaseAuth.instance.currentUser;


  String Membro="";


  final nomeGruppo = TextEditingController();
  final email = TextEditingController();
  final nomeUtente = TextEditingController();


  /**
   * Aggiunge un utente ad un gruppo
   */
  void add() {
    list[email.text.toString().replaceAll(".","'")] = nomeUtente.text.toString();
    setState(() {
      Membro=Membro+nomeUtente.text.toString()+"  "+email.text.toString()+"\n";
    });

    nomeUtente.text="";
    email.text="";

  }

  /**
   * Aggiunge il gruppo al database
   */
  void creaGruppo() {
    DatabaseReference myRef= database.reference().child("gruppi");
    DatabaseReference myRefutenti=database.reference().child("utentiGruppi");

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user= auth.currentUser;
    if(user != null){
      list[user.email.toString().replaceAll(".","")]=user.displayName.toString();
    }
    Gruppo group = Gruppo(nomeGruppo.text.toString(),list);

    String groupid= myRef.push().key.toString();
    myRef.child(groupid).child("nomeGruppo").set(nomeGruppo.text.toString());
    myRef.child(groupid).child("gruppo").set(list).whenComplete(() =>
        list.forEach((key, value) {
          myRefutenti.child(key.replaceAll("'","")).child(groupid).set(nomeGruppo.text.toString());

        }));


  }


  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    final groupnameField = TextField(
      obscureText: false,
      style: style,
      controller: nomeGruppo,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nome del gruppo",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final nomeUtenteField = TextField(
      obscureText: false,
      style: style,
      controller: nomeUtente,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nome Utente",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: email,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );




    final addButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          add();

        },
        child: Text("Aggiungi",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),

    );

    final removeButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Groups()));

        },
        child: Text("Rimuovi",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.red, fontWeight: FontWeight.bold)),
      ),



    );
    final createGroup = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          creaGruppo();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Groups()));

        },
        child: Text("Crea Gruppo",
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

                    Text("Nome del gruppo"),
                    groupnameField,
                      SizedBox(height: 45.0),
                    Text("Nome Componente"),
                    nomeUtenteField,
                    SizedBox(height: 45.0),
                    Text("Email componente"),
                    emailField,
                    SizedBox(height: 45.0),
                    Text('$Membro'),
                    SizedBox(
                      height: 15.0,
                    ),
                    removeButton,
                    SizedBox(
                      height: 15.0,
                    ),
                    addButton,
                    SizedBox(
                      height: 15.0,
                    ),
                    createGroup,
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}