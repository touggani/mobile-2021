import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenue"), centerTitle: true,),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,
              child: Image.asset("assets/logo-appmobile.png", fit: BoxFit.contain),),
              Text("Rebonjour", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
              SizedBox(height: 10,),
              Text("Nom", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              Text("Email", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
              SizedBox(height: 15,),
              ActionChip(label: Text("Deconnexion"), onPressed: (){}), 
            ],
          )
        ),),
    );
  }
}