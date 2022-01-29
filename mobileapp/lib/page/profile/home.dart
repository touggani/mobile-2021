import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobileapp/data/models/user_model.dart';
import 'package:mobileapp/page/authFirebase/login.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loginUser = UserModel();

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get()
        .then((value){
      this.loginUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text("${loginUser.nom} ${loginUser.prenom}", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
                Text("${loginUser.email}", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
                SizedBox(height: 15,),
                ActionChip(label: Text("Deconnexion"), onPressed: (){
                  Deconnexion(context);
                }),
              ],
            )
        ),),
    );
  }

  Future<void> Deconnexion(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Login()));
  }
}