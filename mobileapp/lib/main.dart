import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/screens/navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/screens/globals.dart' as globals;
import 'package:mobileapp/screens/profile.dart';


const String FAVORITES_BOX = "favorites";
const String CONNECTION_BOX = "connection";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(FAVORITES_BOX);
  await Hive.openBox(CONNECTION_BOX);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  FirebaseAuth auth = FirebaseAuth.instance;
  final box = Hive.box(CONNECTION_BOX);

  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Hive.box("connection").put("isLoggin", false);
        print('User is currently signed out!');
      } else {
        Hive.box("connection").put("isLoggin", true);
        print('User is signed in!');
      }

    });
      if(Hive.box("connection").get("isLoggin")){
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
