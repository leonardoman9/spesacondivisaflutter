
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/wrapper.dart';

import 'screens/groups.dart';

/**
 * Entry pointdel'applicazione
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

  User? user= auth.currentUser;
  /**
   * Se l'utente non è loggato, effettua la registrazione
   * Altrimenti, va alla schermata gruppi
   */
  if (user == null) {
    runApp(MyApp());

  } else {
    print(user.displayName.toString());
    runApp(Groups());

  }


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }


}