import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapp/screens/home.dart';
import 'package:mobileapp/screens/registration.dart';
import 'package:mobileapp/screens/navigation.dart';

import 'film.dart';
import 'image.dart';

class FilmDetail extends StatelessWidget {
  const FilmDetail({ Key? key, required this.a, required this.film}) : super(key: key);
  final String a;
  final Film film;

  @override
  Widget build(BuildContext context) {
    List<Film> _films = [];

    return
          MyImage(
              image: film.backdropPath != null
                  ? 'https://image.tmdb.org/t/p/w500/' +
                  film.backdropPath!
                  : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png',
              id: film.id);
    }



  }

