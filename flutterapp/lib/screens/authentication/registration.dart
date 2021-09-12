
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/authentication/login.dart';

/**
 * Classe per effettuare la registrazione di un nuovo utente
 */
class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Registration'),
    );
  }
}
/**
 * Controllers dei vari campi nomeutente, email, password, conferma password
 */
final nomeutente = TextEditingController();
final email = TextEditingController();
final password = TextEditingController();
final confirmpassword = TextEditingController();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, String? title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    Future<void>  _passwordsDoNotMatch() async {
      return showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context){
              return AlertDialog(
                  title: const Text('Errore'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Errore'),
                        Text('Le password non coincidono'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(child:const Text('OK'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        })
                  ],
              );
            },
      );}
  Future<void> tryRegistration(TextEditingController nomeutente,
      TextEditingController email,
      TextEditingController password) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        User? u = userCredential.user;
        u!.updateDisplayName(nomeutente.text);

        await FirebaseAuth.instance.currentUser!.updateDisplayName(nomeutente.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for  that email.');
        }
      } catch (e) {
        print(e);
      }
  }
    final nameField = TextField(
      obscureText: false,
      style: style,
      controller: nomeutente,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nome utente",
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

    final passwordField = TextField(
      controller: password,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final confirmPasswordField = TextField(
      obscureText: true,
      style: style,
      controller: confirmpassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Conferma Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final registrationButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => {
          if(password.text != confirmpassword.text)
       { _passwordsDoNotMatch(),}

          else {
        tryRegistration(nomeutente, email, password),
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => Login())),

    }
        },
        child: Text("Registrati",
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
                    nameField,

                    SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(height: 45.0),
                    confirmPasswordField,
                    SizedBox(
                      height: 35.0,
                    ),

                    SizedBox(
                      height: 15.0,
                    ),
                    registrationButton,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
/**
 * Mostra un AlertDialog a registrazione effettuata
 */
Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Account registrato'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Fatto"),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Fatto'),
      ),
    ],
  );
}




