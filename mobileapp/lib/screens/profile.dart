import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobileapp/screens/login.dart';
import 'globals.dart' as globals;
import 'package:mobileapp/screens/home.dart';
import 'package:mobileapp/screens/navigation.dart';

class Profil extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(globals.isLoggedIn){
      return Navigation();
    }
    return Login();
  }
}