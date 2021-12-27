import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobileapp/screens/home.dart';
import 'package:mobileapp/screens/registration.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  //Firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if(value!.isEmpty){
          return("Entrez votre adresse mail");
        }
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
          return ("Entrez une adresse mail correcte");
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty){
          return("Entrez un mot de passe");
        }
        if(!regex.hasMatch(value)){
          return ("le mot de passe doit être de 6 caracteres minimum");
        }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.password),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mot de passe",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.yellow.shade700,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          Connexion(emailController.text, passwordController.text);
        },
        child: Text(
          "Connexion",
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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Image.asset("assets/logo-appmobile.png",fit: BoxFit.contain,),
                    ),
                    SizedBox(height: 45,),
                    emailField,
                    SizedBox(height: 25,),
                    passwordField,
                    SizedBox(height: 25,),
                    loginButton,
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Vous n'avez pas de compte ? "),
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                        },
                        child: Text("S'inscrire",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),)
                      ],
                    )
                  ],)
              )
            ,)
          ,)
        ,)
      ),
    );
  }


  void Connexion(String email, String password) async{
    if(_formKey.currentState!.validate()){
      await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .then((uid) => {
        Fluttertoast.showToast(msg: "Connexion réussi"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home())),

      }).catchError((e){
        Fluttertoast.showToast(msg: e!.message);
      });
      };
    }
}