import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobileapp/page/authFirebase/login.dart';


class NotLoggedIn extends StatefulWidget {
  const NotLoggedIn({ Key? key }) : super(key: key);

  @override
  _NotLoggedInState createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {



  @override
  Widget build(BuildContext context) {

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.yellow.shade700,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Text(
            "Se connecter",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
            ),
          )),
    );


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Image.asset("assets/logo-appmobile.png",fit: BoxFit.contain,),
                        ),
                        SizedBox(height: 45,),
                        Text("Vous n'etes malheureusement pas connecté !"),
                        SizedBox(height: 45,),
                        loginButton,

                      ],)
                )
                ,)
              ,)
            ,)
      ),
    );
  }

}