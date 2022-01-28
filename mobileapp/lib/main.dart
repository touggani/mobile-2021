import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/screens/Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/globals.dart' as globals;
import 'package:mobileapp/screens/navigation.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        globals.isLoggedIn = false;
        print('User is currently signed out!');
      } else {
        globals.isLoggedIn = true;
        print('User is signed in!');
      }
    });
    print("is logged: ${globals.isLoggedIn}");
    if(globals.isLoggedIn){
       return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Navigation(),
      );
    }
    else{
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Profil(),
      );
    }

  }
}
