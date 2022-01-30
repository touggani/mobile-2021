import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/data/models/film.dart';
import 'package:mobileapp/page/global/navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/page/profile/profile.dart';


const String FAVORITES_BOX = "favorites";
const String CONNECTION_BOX = "connection";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ?
    FirebaseOptions(
      apiKey: "AIzaSyAv-fbA1ky8O4u0CnlORWoqmW_vKiRcdWU", // Your apiKey
      appId: "1:921763117541:web:d53d76a4e241583bc2170c", // Your appId
      messagingSenderId: "921763117541", // Your messagingSenderId
      projectId: "mobileapp-m2-s1", // Your projectId
      storageBucket: 'mobileapp-m2-s1.appspot.com'
    )
  : null,
  );
  Hive.registerAdapter<Film>(FilmAdapter());
  await Hive.initFlutter();
  await Hive.openBox(FAVORITES_BOX);
  await Hive.openBox(CONNECTION_BOX);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        Hive.box("connection").put("uid", user.uid);

        print('User is signed in!');
      }

    });
      if(Hive.box("connection").get("isLoggin") && Hive.box("connection").get("isLoggin") != null){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Navigation(),
        );
      }
      else{
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Profil(),
        );
      }

  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
