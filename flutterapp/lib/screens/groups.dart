import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/controller/newgroup.dart';
import 'package:flutterapp/screens/ListOfProduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterapp/screens/authentication/login.dart';

/**
 * Schermata che mostra i gruppi di cui fa parte l'utente loggato
 */
class Groups extends StatelessWidget {
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

  // final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  late DatabaseReference myRef;
  late DatabaseReference searchgroups;
  List<String> list=[] ;
  List<String> list2= [] ;


  User? user= FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(databaseURL: "https://prova-14ff5-default-rtdb.europe-west1.firebasedatabase.app/");
    myRef = database.reference().child("utentiGruppi");
    searchgroups= database.reference().child("gruppi");

    String? child=user?.email.toString().replaceAll('.','');

    myRef.child(child.toString()).onValue.listen((event) {
      list.clear();
      list2.clear();
      Map<dynamic,dynamic>.from(event.snapshot!.value).forEach((key, value) {
        setState(() {
          list.add(value.toString());
          list2.add(key.toString());

        });
      });
    });



  }




  @override
  Widget build(BuildContext context) {
    User? u = user;
    return Scaffold(

      appBar: AppBar(title: Text('Username:\t ' + user!.displayName.toString())),
      body:Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ListOfProduct(idgroup: list2[index]);
                              }),
                            );

                            print('Container clicked ${list2[index]}' );
                          },
                          child:Container(
                            height: 50,
                            margin: EdgeInsets.all(2),
                            color: Colors.blue[400],
                            //  msgCount[index]>3? Colors.blue[100]: Colors.grey
                            child: Center(
                              child: Text('${list[index]}',
                                style: TextStyle(fontSize: 18),
                              ),

                            ),
                          ));}))]),
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          runApp(NewGroup());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}