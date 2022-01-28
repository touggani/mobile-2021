import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'globals.dart' as globals;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'NotLoggedIn.dart';
import 'home.dart';

class Profil extends StatelessWidget {
  final box = Hive.box("connection");

  @override
  Widget build(BuildContext context) {
    if(Hive.box("connection").get("isLoggin")){
      return Home();
    }
    return NotLoggedIn();
  }
}
