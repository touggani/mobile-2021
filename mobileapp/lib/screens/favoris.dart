import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'globals.dart' as globals;
import 'package:mobileapp/screens/notLoggedIn.dart';


class Favoris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(globals.isLoggedIn){
      return Center(child: Text("Favoris"));
    }
    return NotLoggedIn();

  }
}